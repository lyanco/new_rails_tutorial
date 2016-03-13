require "test_helper"

class SessionsHelperTest < ActionView::TestCase
  include SessionsHelper
  def setup
    @user = users(:lee)
    remember(@user)
    @user2 = users(:notlee)
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

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test "current_user? should match" do
    log_in(@user)
    assert current_user?(@user)
    assert_not current_user?(@user2)
  end

end
