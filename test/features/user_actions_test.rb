require "test_helper"
require "nokogiri"

class UserActionsTest < Capybara::Rails::TestCase


  test "full feature spec" do
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
    #And click the link in my account activation email
    visit Nokogiri::HTML(last_email).css('a')[0].values[0]
    #Then I should see my name and be logged in
    assert_content page, "Account activated"
    assert_content page, 'Test McTesterson'
    #When I log out
    click_link('Log out')
    #Then I should see a prompt to log back in
    assert_content page, 'Log in'

    #When I visit the login page
    click_link('Log in')
    #Then I should see a prompt for email and password
    assert_content page, "Email"
    assert_content page, "Password"

    #When I log in
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')
    #Then I should see my name on the page
    assert_content page, 'Lee Yanco'

    #When I click forget my password
    click_link('Log out')
    click_link('Log in')
    click_link('(forgot password)')
    #And fill in my email
    fill_in('Email', with: 'lee@example.com')
    click_button('Submit')
    #Then I should receive an email to reset my password
    visit Nokogiri::HTML(last_email).css('a')[0].values[0]
    #When I input a new password and submit
    fill_in('Password', with: 'password1')
    fill_in('Confirmation', with: 'password1')
    click_button('Update password')
    assert_content page, 'Lee Yanco'
    #Then I should be able to log in with that password
    click_link('Log out')
    click_link('Log in')
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password1')
    click_button('Log in')
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

    #When I visit the all users page
    click_link("Users")
    #Then I should see a list of users in the system
    assert_content("All users")
    assert_content("Lee Yanco")
    assert_content("Notlee Yanco")
    #And I should see pagination
    assert_content("2")

  end

  test "admin should be able to delete users" do
    #Given I have logged in as an admin
    visit login_path
    fill_in('Email', with: 'admin@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')
    #When I go to the users index
    click_link("Users")
    #Then I should see links to delete
    assert_selector "a", text: "delete", count: 29
    assert_content("Lee Yanco")
    #When I click one
    document = Nokogiri::HTML(page.body)
    links    = document.css('.users').css('li a')
    user_to_delete = links[0].text == 'Admin McAdminson' ?
        links[1].text : links[0].text
    first(:link, "delete").click
    #Then that user should no longer appear
    assert_no_content(user_to_delete)
  end

end