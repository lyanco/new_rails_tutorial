ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require "minitest/rails/capybara"

require "minitest/reporters"
Minitest::Reporters.use!(
    Minitest::Reporters::DefaultReporter.new,
    ENV,
    Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Add more helper methods to be used by all tests here...
end
