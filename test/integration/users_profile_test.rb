require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:lee)
    @micropost = @user.microposts.first
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

end
