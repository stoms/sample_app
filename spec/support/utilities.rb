include ApplicationHelper

def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def try_signup(name,email,password)
  fill_in "Name",         with: name
  fill_in "Email",        with: email
  fill_in "Password",     with: password
  fill_in "Confirmation", with: password
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert')
  end
end

RSpec::Matchers.define :have_title do |title|
  match do |page|
    expect(page).to have_selector('title', text: title)
  end
end
