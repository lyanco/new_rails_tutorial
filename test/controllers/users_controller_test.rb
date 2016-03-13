require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:lee)
    @user2 = users(:notlee)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | RoR Tutorial Sample App"
    assert_instance_of User, assigns(:user)
  end

  test "should get edit" do
    log_in_as(@user)
    get :edit, id: @user.id
    assert_response :success
    assert_select "title", "Edit user | RoR Tutorial Sample App"
    assert_instance_of User, assigns(:user)
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should patch edit when logged in" do
    log_in_as(@user)
    patch :update, { id: @user.id, user: {
                              name: "Lee Yanco2", email: "lee@example.com",
                              password: "password",
                              password_confirmation: "password" } }

    assert_response :redirect
    @user.reload
    assert_equal "Lee Yanco2", @user.name
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user2)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user2)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
