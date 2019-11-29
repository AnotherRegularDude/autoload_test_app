# frozen_string_literal: true

namespace :test do
  desc "Reproduces an error when an application gets into a deadlock during autoloading"
  task :finish_him, %i[autoload_mode] => :environment do |_, args|
    require "open3"

    ENV["AUTOLOAD_MODE"] = args[:autoload_mode] || "zeitwerk"
    Thread.report_on_exception = false
    make_request = proc { |action| Thread.new { HTTP.get("http://localhost:3000/#{action}") } }

    Open3.popen2("rails s", chdir: Rails.root) do |_stdin, stdout, wait_thr|
      Signal.trap("INT") do
        print "Exiting...\n"

        Thread.list
          .then { |threads| threads.select { |thr| thr.status == "run" } }
          .then { |threads| threads - [Thread.current] }
          .each(&:join)
        Process.kill("KILL", wait_thr.pid)
        exit
      end
      stdout.each_line { |line| break if line.match?(/use ctrl\-c/i) }

      loop do
        threads = %w[first second].map(&make_request)
        FileUtils.touch(Rails.root.join("app", "services", "first_module.rb"))
        sleep 0.5
        threads.map(&:kill)
        print "Requested...\n"

        if (debug_body = HTTP.get("http://localhost:3000/rails/locks").body).present?
          print debug_body
          break
        end
      end

      Process.kill("KILL", wait_thr.pid)
    end
  end

  desc "Access to three constants from different threads, which causes script execution to freeze"
  task access_in_threads: :environment do
    200.times do
      p "Trying..."
      Rails.application.reloader.reload!

      # Sleep forever
      Thread.new { FirstModule }
      Thread.new { SecondModule }
      Thread.new { ThirdModule }

      SecondModule # When we access this constant, script stuck or crash with segmentation fault
    end
  end
end
