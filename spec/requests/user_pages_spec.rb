require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "signup page" do
    let(:page_title) { "Sign Up" }
    let(:page_content) { "Sign up" }
    let(:submit) { "Create my account" }
    before { visit signup_path }

    it { should have_content(page_content) }
    it { should have_title(full_title(page_title)) }

    describe "with invalid information" do
      it "should not create a user account" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    describe "with valid information" do
      before { try_signup("Example User", "user@example.com", "foobar") }
      it "should create a user account" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

    describe "with invalid information" do
      before { try_signup("Example User", "user@example", "foobar") }
      describe "after submission" do
        before { click_button submit }
        it { should have_title(page_title) }
        it { should have_content('error') }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

end
