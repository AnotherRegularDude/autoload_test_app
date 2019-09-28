# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module AutoloadTestApp
  class Application < Rails::Application
    config.load_defaults 6.0

    config.public_file_server.enabled = false
    config.generators.system_tests = nil
    config.middleware.delete ActionDispatch::ContentSecurityPolicy::Middleware
    config.middleware.insert_before Rack::Sendfile, ActionDispatch::DebugLocks
  end
end
