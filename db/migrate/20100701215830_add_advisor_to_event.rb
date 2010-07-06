class AddAdvisorToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :advisor_id, :integer
    add_index :events, :advisor_id
  end

  def self.down
    remove_column :events, :advisor_id
  end
end
