require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | RoR Tutorial Sample App"
    assert_instance_of User, assigns(:user)
  end

end
