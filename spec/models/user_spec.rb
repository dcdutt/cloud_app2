require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Sample User", :email => "user@abc.com", :phone => 16138768788 }
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

end
