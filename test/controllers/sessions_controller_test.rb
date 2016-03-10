require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @user = User.create(name:  "Example User2",
                             email: "user2@example.com",
                             password:              "password2",
                             password_confirmation: "password2" )
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should post login" do
    post :create, session: { email: "user2@example.com",
                             password: "password2" }
    assert_response :redirect
  end

  test "should destroy login" do
    post :create, session: { email: "user2@example.com",
                             password: "password2" }
    delete :destroy
    assert_response :redirect
  end



end
