class Student < ActiveRecord::Base
  acts_as_authentic
  belongs_to :advisor
  has_one :event
  validates_presence_of :name, :advisor_id
end
