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

class User < ActiveRecord::Base
  attr_accessible :name, :email, :phone
  def before_validation_on_create
   self.phone = phone.gsub(/[^0-9]/, "")
  end

  EmailRegex = /\A[a-z+\-\_.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PhoneRegex = /^[+\/\-() 0-9]+$/

  validates_presence_of :name, :email, :phone
  validates_length_of :name, :maximum => 40
  validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :phone, :is => 11
  validates_format_of :phone, :with => PhoneRegex
  validates_uniqueness_of :phone

end
