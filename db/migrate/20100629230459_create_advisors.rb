class CreateAdvisors < ActiveRecord::Migration
  def self.up
    create_table :advisors do |t|
      t.string :login
      t.string :crypted_password, :null => false  
      t.string :password_salt, :null => false  
      t.string :persistence_token, :null => false 
      t.timestamps
    end
  end

  def self.down
    drop_table :advisors
  end
end
