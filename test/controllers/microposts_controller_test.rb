require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @user = users(:lee)
    @user2 = users(:notlee)
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Lorem Ipsum" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "should create when logged in" do
    log_in_as(@user)
    assert_difference 'Micropost.count', 1 do
      post :create, micropost: { content: "Lorem Ipsum" }
    end
    assert_redirected_to root_path

  end

  test "should destroy when logged in" do
    log_in_as(@user)
    assert_difference 'Micropost.count', -1 do
      delete :destroy, id: @micropost
    end
    assert_redirected_to root_path
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(@user2)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @user.microposts.first
    end
    assert_redirected_to root_path
  end


end
