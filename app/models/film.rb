class Film < ActiveRecord::Base
  attr_accessible :netflix_id, :rating, :title

  validates_presence_of :netflix_id, :rating, :title
end
