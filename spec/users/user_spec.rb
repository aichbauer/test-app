require 'rails_helper.rb'

feature 'Create new user' do
  scenario 'can create new user' do
    visit '/users'
    click_link 'New User'
    fill_in 'Name', :with => 'Test'
    click_button 'Create User'
    expect(page).to have_content('User was successfully created.')
  end
end