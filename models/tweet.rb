class Tweet < ActiveRecord::Base
  validates_uniqueness_of :t_id
end