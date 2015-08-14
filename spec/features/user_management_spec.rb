require 'byebug'
require_relative '../../app/models/user'

feature 'User sign up' do
  
  scenario 'I can sign up as a new user' do
      expect { sign_up }.to change(User, :count).by(1)
      expect(page).to have_content('Welcome, alice@example.com')
      expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users') # current_path is a helper provided by Capybara
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'requires the user to enter an email' do
    expect { sign_up(email: '') }.not_to change(User, :count)
    expect(current_path).to eq('/users') # current_path is a helper provided by Capybara
    expect(page).to have_content 'Email must not be blank'
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up
    expect { sign_up }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User sign in' do

 let(:user) do
   User.create(email: 'user@example.com',
               password: 'secret1234',
               password_confirmation: 'secret1234')
 end

 scenario 'with correct credentials' do
   sign_in(email: user.email,   password: user.password)
   expect(page).to have_content "Welcome, #{user.email}"
 end
end

feature 'User signs out' do

  before(:each) do
    User.create(email: 'test@test.com',
                password: 'test',
                password_confirmation: 'test')
  end

  scenario 'while being signed in' do
    sign_in(email: 'test@test.com', password: 'test')
    click_button 'Sign out'
    expect(page).to have_content('goodbye!') # where does this message go?
    expect(page).not_to have_content('Welcome, test@test.com')
  end
end

feature 'Password reset' do

 scenario 'requesting a password reset' do
   user = User.create(email: 'test@test.com', password: 'secret1234',
                      password_confirmation: 'secret1234')
   visit '/users/password_reset'
   fill_in 'Email', with: user.email
   click_button 'Reset password'
   user = User.first(email: user.email)
   expect(user.password_token).not_to be_nil
   expect(page).to have_content 'Check your emails'
 end

 scenario 'resetting password' do
   user = User.first
   user.password_token = 'token'
   user.save

   visit "/users/password_reset/#{user.password_token}"
   expect(page.status_code).to eq 200
   expect(page).to have_content 'Enter a new password'
 end
end