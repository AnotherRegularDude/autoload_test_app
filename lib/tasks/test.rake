# frozen_string_literal: true

namespace :test do
  desc "Reproduce problem with deadlock"
  task reproduce_error: :environment do
    require "open3"

    Thread.report_on_exception = false
    make_request = proc { |action| Thread.new { HTTP.get("http://localhost:3000/#{action}") } }

    Open3.popen2("rails s", chdir: Rails.root) do |_stdin, stdout, wait_thr|
      stdout.each_line { |line| break if line.match?(/use ctrl\-c/i) }

      loop do
        threads = %w[first second].map(&make_request)
        FileUtils.touch(Rails.root.join("app", "services", "first_module.rb"))
        sleep 1
        threads.map(&:kill)
        p "Requested..."

        if (debug_body = HTTP.get("http://localhost:3000/rails/locks").body).present?
          print debug_body
          break
        end
      end

      Process.kill("KILL", wait_thr.pid)
      wait_thr.join
    end
  end

  desc "Crash Ruby"
  task dump_core: :environment do
    loop do
      p "Trying..."
      Rails.application.reloader.reload!

      Thread.new { FirstModule }
      Thread.new { SecondModule }
      Thread.new { ThirdModule }

      SecondModule # Hangs here forever
    end
  end
end
