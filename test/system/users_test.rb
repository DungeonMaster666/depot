require "application_system_test_case"
require 'pry'

class UsersTest < ApplicationSystemTestCase

  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit users_url
    click_on "New User"

    fill_in "Name", with: 'Dave Chaplin'
    fill_in "New password:", with: 'secret'
    fill_in "New password confirm:", with: 'secret'
    click_on "Create User"

    assert_text "User Dave Chaplin was successfully created"
    assert_text "Users"
  end

  test "updating a User" do

    visit users_url
    click_on "Edit", match: :first

    fill_in "Name", with: 'Dave Chaplin'
    fill_in "Current password:", with: 'secret'
    fill_in "New password:", with: 'secret2'
    fill_in "New password confirm:", with: 'secret2'
    click_on "Update User"

    assert_text "User Dave Chaplin was successfully updated."
    assert_text "Users"
  end

  test "destroying a User" do
    visit users_url

    binding.pry
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User was successfully destroyed."
  end

  test "need access after logout" do
    visit users_url
    binding.pry
    logout()
  end
end
