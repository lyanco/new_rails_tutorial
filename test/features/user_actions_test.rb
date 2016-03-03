require "test_helper"

class UserActionsTest < Capybara::Rails::TestCase

  test "layout should include name and email" do
    visit users_new_path
    assert_content page, "Name"
    assert_content page, "Email"
  end

  test "submitting form should create a new user" do
    visit users_new_path
    fill_in('Name', with: 'Test McTesterson')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'abcdefgh')
    fill_in('Confirmation', with: 'abcdefgh')
    click_link_or_button('Create my account')

    assert_content page, "Welcome to the Sample App!"
    assert_content page, 'Test McTesterson'
  end


  test "failing form should stay on same page" do
    visit users_new_path
    fill_in('Name', with: 'Test McTesterson')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'ssssss')
    fill_in('Confirmation', with: 'abcdefgh')
    click_link_or_button('Create my account')

    assert current_path, users_new_path
  end

  test "visiting login should show email and password" do
    visit login_path
    assert_content page, "Email"
    assert_content page, "Password"
  end

  test "I should log in and see my name" do
    visit login_path
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')

    assert_content page, 'Lee Yanco'

  end

end
