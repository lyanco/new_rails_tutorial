require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
  end

  test "root page should show microposts to user when logged in" do
    log_in_as(@user)
    get root_path
    assert_match "Lee Yanco", response.body
    assert_select "textarea#micropost_content"
  end

  test "root page should show my feed when logged in" do
    log_in_as(@user)
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete a post.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

end
