class AddPinToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mobile_pin, :string
  end

  def self.down
    remove_column :users, :mobile_pin
  end
end
