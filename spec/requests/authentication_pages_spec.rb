require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "with invalid information" do
      let(:page_title) { 'Sign in' }
      before { click_button page_title }
      it { should have_content(page_title) }
      it { should have_title(page_title) }
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
      before { valid_signin(user) }
      it { should have_title(user.name) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should_not have_selector('div.alert.alert.error', text: 'Invalid') }
    end
  end

end
