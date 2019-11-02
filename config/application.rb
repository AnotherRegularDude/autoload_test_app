# frozen_string_literal: true

require_relative "boot"

require "rails"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module AutoloadTestApp
  class Application < Rails::Application
    config.load_defaults 6.0
    config.autoloader = ENV["AUTOLOAD_MODE"]&.to_sym || :zeitwerk

    config.public_file_server.enabled = false
    config.generators.system_tests = nil
    config.middleware.delete ActionDispatch::ContentSecurityPolicy::Middleware
    config.middleware.insert_before Rack::Sendfile, ActionDispatch::DebugLocks
  end
end
