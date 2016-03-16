require "test_helper"

class UsersDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:lee)
    @user2 = users(:notlee)
  end

  test 'admin should be able to delete users' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@user2)
    end
  end

  test 'should fail if not admin' do
    assert_no_difference 'User.count' do
      delete user_path(@user2)
    end
    assert_not @user2.nil?

    log_in_as(@user)

    assert_no_difference 'User.count' do
      delete user_path(@user2)
    end
    assert_not @user2.nil?
  end

end
