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
  end #    "signup page"

  describe "profile page" do
    
    describe "when non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      before { visit user_path(user) }
      it { should have_content(user.name) }
      it { should have_title(user.name) }
      it { should_not have_content('Admin User')}
    end
    
    describe "when admin user" do
      let(:admin) { FactoryGirl.create(:admin) }  
      before do
        sign_in admin
        visit user_path(admin)
      end
      it { should have_content('Admin User')}
    end
    
  end #   "profile page"

  describe "edit" do

    let(:page_title) { "Edit User" }
    let(:page_content) { "Update your profile" }
    let(:gravatar_link) { 'http://gravatar.com/emails' }
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in(user)
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content(page_content) }
      it { should have_title(full_title(page_title)) }
      it { should have_link('change', href: gravatar_link) }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end
  
    describe "with valid information" do
      let(:newname) { "New Name" }
      let(:newemail) { "new@email.com" }

      before do
        fill_in "Name",             with: newname
        fill_in "Email",            with: newemail
        fill_in "Password",         with: user.password
        fill_in "Confirmation",     with: user.password
        click_button "Save changes"
      end

      it { should have_title(newname) }
      it { should have_selector('div.alert.alert-success', text: "Profile updated!") }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq newname }
      specify { expect(user.reload.email).to eq newemail }
    end
    
#    describe "forbidden attributes" do

#      let(:params) do
#        { user: { admin: true, password: user.password,
#                  password_confirmation: user.password } }
#      end

#      before { patch user_path(user), params }
#      specify { expect(user.reload).not_to be_admin }
#    end
    
  end #   "edit"
  
  describe "index" do
    let(:page_title) { "All Users" }
    let(:page_content) { "All Users" }
    let(:gravatar_link) { 'http://gravatar.com/emails' }
    let(:user1) { FactoryGirl.create(:user, name: 'Bill', email: 'bill@example.com') }
    let(:user2) { FactoryGirl.create(:user, name: 'Ben',  email: 'ben@example.com') }
   
    before(:each) do
      sign_in(user1)
      visit users_path
    end
      
    describe "page" do
      it { should have_title(page_title) } 
      it { should have_content(page_content) }
      
      describe "pagination" do
        before(:all) { 30.times { FactoryGirl.create(:user) } }
        after(:all)  { User.delete_all }

        it { should have_selector('div.pagination') }
        it "should list each user" do
          User.paginate(page: 1).each do |user|
            expect(page).to have_selector('li', text: user.name)
          end
        end
      end
      
      #describe "delete links" do
      #  it { should_not have_link('delete') }

      #  describe "as an admin user" do
      #    let(:admin) { FactoryGirl.create(:admin) }

#          before do
 #           sign_in admin
  #          visit users_path
   #       end
    #      
     #     it { should have_link('delete', href: user_path(User.first)) }
#
 #         it "should be able to delete another user" do
  #          expect do
   #           click_link('delete', match: :first)
    #        end.to change(User, :count).by(-1)
     #     end
      #    
       #   it { should_not have_link('delete', href: user_path(admin)) }
#
 #       end #    "as an admin user"
#
 #     end #    "delete links"     
      
      describe "delete links" do

        it { should_not have_link('delete') }

        describe "as an admin user" do
          let(:admin) { FactoryGirl.create(:admin) }
          before do
            sign_in admin
            visit users_path
          end

          it { should have_link('delete', href: user_path(User.first)) }
          it "should be able to delete another user" do
            expect { click_link('delete', match: :last) }.to change(User, :count).by(-1)
          end
          it { should_not have_link('delete', href: user_path(admin)) }
        end
      end
  
      
    end #    "page"
  end #    "index"
end #    "User pages"

