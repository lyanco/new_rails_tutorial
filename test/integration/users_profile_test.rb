require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:lee)
    @micropost = @user.microposts.first
    @other_user = users(:archer)
    @third_user = users(:lana)
  end

  test "micropost should appear on the user show" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert @user.microposts.any?
    assert_select 'h1>img.gravatar'
    assert_match "(" + @user.microposts.count.to_s + ")", response.body

    assert_select 'div.pagination'
    micropost_id = "li#micropost-" + @micropost.id.to_s
    assert_select micropost_id
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "following should appear on the user show" do
    get user_path(@user)
    assert_select '#following', text: "2"
    assert_select '#followers', text: "2"
    assert_select 'input[type=submit][value=Follow]', count: 0
    assert_select 'input[type=submit][value=Unfollow]', count: 0
  end

  test "actions should appear on other user shows" do
    log_in_as(@user)
    get user_path(@other_user)
    assert_select 'input[type=submit][value=Follow]'
    @user.follow(@other_user)
    get user_path(@other_user)
    assert_select 'input[type=submit][value=Unfollow]'
  end

end
