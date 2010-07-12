class AddStudentToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :student_id, :integer
    add_index :events, :student_id
  end

  def self.down
    remove_column :events, :student_id
  end
end
