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
      it { should have_selector('div.alert.alert-fail', text: 'Invalid email/password combination!') }
      describe "after visiting another page" do
          before { click_link "Home" }
            it { should_not have_selector('div.alert.alert-fail') }
      end
    end
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }
      it { should have_title(user.name) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should_not have_selector('div.alert.alert.error', text: 'Invalid') }
    end
  end

  describe "Authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to access protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",  with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        it { should have_title('Edit User') }
      end #    "when attempting to access protected page"
      
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          # rails 4
          #before { patch user_path(user) }
          # rails 3
          before { put user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

      end #   "in the Users controller"
      
    end #   "for non-signed-in users"

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong.user@example.org') }
      before { sign_in user, no_capybara: true }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end
      describe "submitting a PATCH request to the Users#update action" do
        # rails 4
        #before { patch user_path(wrong_user) }
        # rails 3
        before { put user_path(wrong_user) }
        specify {expect(response).to redirect_to(root_url) }
      end

    end #    "as wrong user"
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end #   "Authorization"
end
