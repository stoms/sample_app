require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_content('Sign in') }
      it { should have_selector('title', text: 'Sign in') }
      #The following just does not match <div class="alert alert-error">
      #as claimed in the Hartl RailsTutorial
      #it { should have_selector('div.alert.alert-error') }
      it { should have_selector('div.alert') }
      describe "after visiting another page" do
          before { click_link "Home" }
            it { should_not have_selector('div.alert.alert-error') }
      end
    end
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      it { should have_selector('title', text: user.name ) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should_not have_selector('div.alert.alert.error', text: 'Invalid') }
    end
  end

end
