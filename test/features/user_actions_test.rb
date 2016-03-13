require "test_helper"

class UserActionsTest < Capybara::Rails::TestCase


  test "full feature" do
    #layout should include name and email
    visit users_new_path
    assert_content page, "Name"
    assert_content page, "Email"
    #When I input bad information
    fill_in('Name', with: 'Test McTesterson')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'ssssss')
    fill_in('Confirmation', with: 'abcdefgh')
    click_link_or_button('Create my account')
    #Then the signup should render again
    assert current_path, users_new_path
    #When I enter good information
    fill_in('Name', with: 'Test McTesterson')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'abcdefgh')
    fill_in('Confirmation', with: 'abcdefgh')
    click_link_or_button('Create my account')
    #Then I should see my name and a welcome message and be logged in
    assert_content page, "Welcome to the Sample App!"
    assert_content page, 'Test McTesterson'
    #When I log out
    click_link('Log out')
    #Then I should see a prompt to log back in
    assert_content page, 'Log in'

    #When I visit the login page
    visit login_path
    #Then I should see a prompt for email and password
    assert_content page, "Email"
    assert_content page, "Password"

    #When I log in
    visit login_path
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')
    #Then I should see my name on the page
    assert_content page, 'Lee Yanco'

    #When I go to settings
    click_link('Settings')
    assert_content page, 'Update your profile'
    assert_content page, 'Confirmation'
    #And change my password
    fill_in('Password', with: 'password')
    fill_in('Confirmation', with: 'password')
    click_button('Save changes')
    #Then I should see a prompt that my profile has been updated
    assert_content page, 'Profile updated'
  end

end