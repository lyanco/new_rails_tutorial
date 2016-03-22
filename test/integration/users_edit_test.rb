require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:lee)
    @user2 = users(:notlee)
  end

  test "edit should patch for the user" do
    get edit_user_path(@user)
    patch user_path(@user), user: { name: "bla",
                                    email: "blahblah",
                                    password: "",
                                    password_confirmation: "" }
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                        email: email,
                                        password: "",
                                        password_confirmation: "" }
    assert_not flash.empty?, "success flash should show"
    assert_redirected_to @user
    @user.reload
    follow_redirect!
    assert_template 'users/show'
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "edit should fail when passwords don't match" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                         email: email,
                                         password: "password1",
                                         password_confirmation: "password2" }
    assert_template 'users/edit'
    @user.reload
    assert_not_equal @user.name, name
    assert_not_equal @user.email, email
  end

  test "edit should redirect to login for non logged in users" do
    get edit_user_path(@user2)
    assert_redirected_to login_path
  end

  test "edit should not render for someone else" do
    log_in_as(@user)
    get edit_user_path(@user2)
    assert_redirected_to root_url
  end

  test "edit should not patch for someone else" do
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user2), user: { name: name,
                                         email: email,
                                         password: "password",
                                         password_confirmation: "password" }
    follow_redirect!
    assert_not_equal @user2.name, name
    assert_not_equal @user2.email, email
    assert_template "sessions/new"
    log_in_as(@user)
    assert is_logged_in?
    assert @user.name, "Lee Yanco"
    patch user_path(@user2), user: { name: name,
                                          email: email,
                                          password: "password",
                                          password_confirmation: "password" }
    assert_not_equal @user2.name, name
    assert_not_equal @user2.email, email
    assert_redirected_to root_url
  end




end
