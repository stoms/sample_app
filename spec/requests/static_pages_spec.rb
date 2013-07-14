require 'spec_helper'
describe "Static pages" do
    let(:common_title) {'Ruby on Rails Tutorial Sample App'}
    let(:common_root) {'/static_pages'}
    describe "Home page" do
        it "should have the h1 'Sample App'" do
          visit "#{common_root}/home"
          page.should have_selector('h1', :text => 'Sample App')
        end
        it "should have the right title" do
          visit "#{common_root}/home"
          page.should have_selector('title',
            :text => "#{common_title}")
        end
        it "should not have a custom page title" do
          visit "#{common_root}/home"
          page.should_not have_selector('title', :text => '| Home')
        end
    end
    describe "Help page" do
        it "should have the h1 'Help'" do
          visit "#{common_root}/help"
          page.should have_selector('h1', :text => 'Help')
        end
        it "should have the right title" do
          visit "#{common_root}/help"
          page.should have_selector('title',
            :text => "#{common_title} | Help")
        end
    end
    describe "Contact page" do
        it "should have the h1 'Contact'" do
          visit "#{common_root}/contact"
          page.should have_selector('h1', :text => 'Contact')
        end
        it "should have the right title" do
          visit "#{common_root}/contact"
          page.should have_selector('title',
            :text => "#{common_title} | Contact")
        end
    end
    describe "About page" do
        it "should have the h1 'About Us'" do
          visit "#{common_root}/about"
          page.should have_selector('h1', :text => 'About Us')
        end
        it "should have the right title" do
          visit "#{common_root}/about"
          page.should have_selector('title',
            :text => "#{common_title} | About Us")
        end
    end
end
