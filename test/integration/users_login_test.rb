require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
  end

  test "login should render" do
    get login_path
    assert_template 'sessions/new'
  end

  test "log in with valid information followed by logout" do
    get login_path
    post login_path, session: { email: "lee@example.com",
                                             password: "password"}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
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

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end



end
