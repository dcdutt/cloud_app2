require 'spec_helper'

describe UsersController do
  integrate_views

  describe "GET 'show'" do

	before(:each) do
	  @user = Factory(:user)
	  # Arrange for User.find(params[:id]) to find the right user.
	     User.stub!(:find, @user.id).and_return(@user)
	end

	it "should be successful" do
	    get :show, :id => @user
	    response.should be_success
	end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_tag("title", /Sign up/)
    end
  end

  describe "GET 'edit'" do
      before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
  end

  it "should be successful" do
      get :edit, :id => @user
      response.should be_success
  end

  it "should have the right title" do
     get :edit, :id => @user
     response.should have_tag("title", /edit user/i)
  end

    #it "should have a link to change the Gravatar" do
      #get :edit, :id => @user
      #gravatar_url = "http://gravatar.com/emails"
      #response.should have_tag("a[href=?]", gravatar_url, /change/i)
   #end
  end

  describe "PUT 'update'" do
	before(:each) do
	   @user = Factory(:user)
	   test_sign_in(@user)
	   User.should_receive(:find).with(@user).and_return(@user)
	end

	describe "failure" do
	   before(:each) do
	     @invalid_attr = { :email => "", :name => "" }
	     @user.should_receive(:update_attributes).and_return(false)
	   end

	   it "should render the 'edit' page" do
	     put :update, :id => @user, :user => {}
	     response.should render_template('edit')
	   end

	   it "should have the right title" do
	     put :update, :id => @user, :user => {}
	     response.should have_tag("title", /edit user/i)
	   end
	end
	
	describe "success" do
	  before(:each) do
	    @attr = { :name => "New Name", :email => "user@example.org",
:password => "barbaz", :password_confirmation => "barbaz" }
	    @user.should_receive(:update_attributes).and_return(true)
	  end

	  it "should redirect to the user show page" do
	    put :update, :id => @user, :user => @attr
	    response.should redirect_to(user_path(@user))
	  end

	  it "should have a flash message" do
	    put :update, :id => @user, :user => @attr
	    flash[:success].should =˜ /updated/
	  end
	end

   end	

end
