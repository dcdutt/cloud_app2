class AddPhoneUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :phone, :unique => true
  end

  def self.down
    remove_index :users, :phone
  end
end
