require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
    @other_user = users(:malory)
    @third_user = users(:notlee)
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
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert assigns[:micropost].picture?
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
    get user_path(users(:notlee))
    assert_select 'a', text: 'delete', count: 0
  end

  test "following should appear on the user show" do
    log_in_as(@user)
    get root_path
    #puts response.body
    assert_select '#following', text: "2"
    assert_select '#followers', text: "2"
  end


end
