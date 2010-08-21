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
require 'rubygems'
require 'httparty'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :phone, :password, :password_confirmation, :mobile_pin
 
  include HTTParty
  format :xml

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
  validates_length_of :phone, :is => 10
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
 
     def has_pin?
       # "verified" == testauth()
       phoneOTP()
     end

     def self.authenticate(email, submitted_password)
        user = find_by_email(email)
        return nil if user.nil?
        if user.has_password?(submitted_password)
           #-- make phone call to verify pin
           return user if user.has_pin?
        else  
           return nil
        end
     
         
     end

     def remember_me!
	  self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
	  save_without_validation
     end

     # Phone based OTP
     def phoneOTP()
         mobile_msg = 'The pin is 1234'
         self.class.post('http://api.tropo.com/1.0/sessions?action=create&token=6ac7af075442e54fb60d1f7638a3e552211a6744df32a7a22c1e36ee45aead120cad176533b5db4ffa42d653&customerName=Dipak&message=MESSAGE', :query => {:numberToDial => phone, :message => mobile_msg})
     end

     # Make web service call to phone based authentication!
      def testauth()
        wsuser = self.class.post('https://secure.ifbyphone.com/ibp_api.php?api_key=2933aadaf1119975ce4cd8aa4890ad3017722db6&action=verifymenow.verify&verify_id=1541', :query => {:phone_number => phone, :pin => mobile_pin})
        # Write exception code here

        #puts wsuser
        wsuser.each do |status|
           #puts status[1]['result']
           #-- code for user sign in session goes here...
           return status[1]['result']
        end
        return nil
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
