require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  def setup
    @user = users(:lee)
    @other_user = users(:notlee)
  end

  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end

  test "successful follow and unfollow should redirect to that user" do
    log_in_as(@user)
    assert_difference 'Relationship.count', 1 do
      post :create, followed_id: @other_user.id
    end
    assert_redirected_to user_path(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference 'Relationship.count', -1 do
      delete :destroy, id: relationship.id
    end
    assert_redirected_to user_path(@other_user)
  end



end