require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
  end

  test "login should render" do
    get login_path
    assert_template 'sessions/new'
  end

  test "user should be able to log in with valid information" do
    get login_path
    post login_path, session: { email: "lee@example.com",
                                             password: "password"}
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "user should fail to log in with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post_via_redirect login_path, session: { email: "bad@example.com",
                                          password: "badpass"}
    assert_template 'sessions/new'
  end

  test "user login failure should show flash only once" do
    get login_path
    post_via_redirect login_path, session: { email: "bad@example.com",
                                             password: "badpass"}
    assert_not flash.empty?, "flash does not show on first page"
    get root_path
    assert flash.empty?, "flash shows on second page"
  end

end
