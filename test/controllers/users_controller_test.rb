require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:lee)
    @user2 = users(:notlee)
    @admin = users(:admin)
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

  test "should get index" do
    log_in_as(@user)
    get :index
    assert_response :success
    assert_equal User.first, assigns(:users).first
    assert_select "title", "Users | RoR Tutorial Sample App"
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should respond to delete" do
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end

  test "should not delete for non-admins" do
    #puts @user
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_path
    #puts @user
    assert_not @user.nil?
    log_in_as(@user2)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
    #puts @user
    assert_not @user.nil?

  end

  test "should not be able to add an admin flag" do
    post :create, user: { name: "1", email: "newuser@example.com",
                                    password: "password", password_confirmation:"password",
                                    admin: true }
    @newuser = User.find_by_email("newuser@example.com")
    assert_not @newuser.admin?
    patch :update, id: @user, user: { admin: true }
    @user.reload
    assert_not @user.admin?
    log_in_as(@user)
    patch :update, id: @user, user: { admin: true }
    @user.reload
    assert_not @user.admin?
  end

  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end

end
