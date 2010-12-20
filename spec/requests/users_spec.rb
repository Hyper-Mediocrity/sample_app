require 'spec_helper'

describe "Users" do

  describe "signup" do
    
    describe "failure" do
      it "should not make a new user" do
        lambda do
          user = User.new(:name => "",
                          :email => "",
                          :password => "",
                          :password_confirmation => "")
          integration_sign_up(user)
          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      it "should make a new user" do
        lambda do
          user = User.new(:name => "Example User",
                          :email => "user@example.com",
                          :password => "foobar",
                          :password_confirmation => "foobar")
          integration_sign_up(user)
          response.should have_selector('div.flash.success',
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
    
  end

  describe "signin" do
    before(:each) do
      @user = Factory(:user)
    end
    
    
    describe "failure" do
      it "should not sign a user in" do
        @user.email = ""
        @user.password = ""
        integration_sign_in(@user)
        response.should have_selector('div.flash.error', :content => "Invalid")
        response.should render_template('sessions/new')
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do
        integration_sign_in(@user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
    
  end
  
end
