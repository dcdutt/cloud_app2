require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
	:name => "Sample User", 
	:email => "user@abc.com", 
	:phone => "16138768788",
	:password => "userpass",
	:password_confirmation => "userpass" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do 
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should reject names that are longer than 40 characters" do
    long_name = "a" * 41
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should require an email address" do 
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do 
    addresses = %w[user@abc.com first.last@abc.jp last.first@xyz.bar.org]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do 
    addresses = %w[user@abc,com first.last@abc. first_at_xyz.org]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # store email address in DB
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should require a phone number" do 
    no_phone_user = User.new(@attr.merge(:phone => ""))
    no_phone_user.should_not be_valid
  end

  it "should reject duplicate phone numbers" do
    # store phone number in DB
    User.create!(@attr)
    user_with_duplicate_phone = User.new(@attr)
    user_with_duplicate_phone.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
       pass_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
       pass_user.should_not be_valid 
    end

    it "should require a matching password confirmation" do
       User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short_pass = "a" * 5
      hash = @attr.merge(:password => short_pass, :password_confirmation => short_pass)
      hash = User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long_pass = "a" * 41
      hash = @attr.merge(:password => long_pass, :password_confirmation => long_pass)
      hash = User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
	it "should be true if the passwords match" do
		@user.has_password?(@attr[:password]).should be_true
         	 end
	it "should be false if the passwords dont match" do
		@user.has_password?("invalid").should be_false
	end
    end

    describe "authenticate method" do

	it "should return nil on email/password mismatch" do
	  wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
	  wrong_password_user.should be_nil
	end

	it "should return nil for an email address with no user" do
	  nonexistent_user = User.authenticate("nonuser@foo.com", @attr[:password])
	  nonexistent_user.should be_nil
	end

	it "should return the user on email/password match" do
	   matching_user = User.authenticate(@attr[:email], @attr[:password])
	   matching_user.should == @user
	end

    end

  end

    describe "remember me" do
	before(:each) do
	    @user = User.create!(@attr)
	end

	it "should have a remember token" do
	   @user.should respond_to(:remember_token)
	end

	it "should have a remember_me! method" do
	   @user.should respond_to(:remember_me!)
	end

	it "should set the remember token" do
	   @user.remember_me!
	   @user.remember_token.should_not be_nil
	end

   end

end
