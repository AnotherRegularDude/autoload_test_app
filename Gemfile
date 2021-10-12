# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "bootsnap", ">= 1.4.2", require: false
gem "http"
gem "puma", "~> 4.3.9"
gem "rails", "~> 6.0.0"

group :development, :test do
  gem "pry-byebug"
  gem "pry-rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end
