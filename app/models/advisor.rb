class Advisor < ActiveRecord::Base
  acts_as_authentic
  has_many :events
end
