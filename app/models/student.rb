class Student < ActiveRecord::Base
  acts_as_authentic
  belongs_to :advisor
  has_one :event
end
