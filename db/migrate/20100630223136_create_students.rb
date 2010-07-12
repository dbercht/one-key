class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :email
      t.string :name
      t.belongs_to :advisor 
      t.string :crypted_password, :null => false  
      t.string :password_salt, :null => false  
      t.string :persistence_token, :null => false  
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
