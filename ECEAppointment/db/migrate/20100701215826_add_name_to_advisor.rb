class AddNameToAdvisor < ActiveRecord::Migration
  def self.up
    add_column :advisors, :name, :string
  end

  def self.down
    remove_column :advisors, :name
  end
end
