require "test_helper"

class SessionsHelperTest < ActionView::TestCase
  include SessionsHelper
  def setup
    @user = users(:lee)
  end


  test "should return nil for current user" do
    assert current_user.nil?
    assert !logged_in?
  end

  test "should return user for current user when logged in" do
    log_in(@user)
    assert_equal @user.id, session[:user_id]
    assert !current_user.nil?
    assert !current_user.nil?
    assert logged_in?
  end

  test "should log out user" do
    log_in(@user)
    assert !current_user.nil?
    log_out
    assert current_user.nil?
  end

end
