# == Schema Information
# Schema version: 20100705215413
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :phone, :password, :password_confirmation, :mobile_pin

#  def before_validation_on_create
#   self.phone = phone.gsub(/[^0-9]/, "")
#  end

  EmailRegex = /\A[a-z,0-9+\-\_.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PhoneRegex = /^[+\/\-() 0-9]+$/
  PinRegex = /^[0-9]+$/

  validates_presence_of :name, :email, :phone
  validates_length_of :name, :maximum => 40
  validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :phone, :is => 11
  validates_format_of :phone, :with => PhoneRegex
  validates_uniqueness_of :phone

  # Automatically create the virtual attribute 'password_confirmation'.
  validates_confirmation_of :password

  # Password validations.
  validates_presence_of :password
  validates_length_of :password, :within => 6..40

  # PIN validations.
  validates_presence_of :mobile_pin
  validates_length_of :mobile_pin, :is => 4
  validates_format_of :mobile_pin, :with => PinRegex

  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
     def has_password?(submitted_password)
        encrypted_password == encrypt(submitted_password)
     end

     def self.authenticate(email, submitted_password)
        user = find_by_email(email)
        return nil if user.nil?
        return user if user.has_password?(submitted_password)
     end

     def remember_me!
	  self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
	  save_without_validation
     end

  private
     def encrypt_password
	  unless password.nil?
	   self.salt = make_salt
         self.encrypted_password = encrypt(password)
     	  end
     end

     def encrypt(string)
        secure_hash("#{salt}#{string}")
     end

     def make_salt
	  secure_hash("#{Time.now.utc}#{password}")
     end  	   

     def secure_hash(string)
	   Digest::SHA2.hexdigest(string)
     end

end
