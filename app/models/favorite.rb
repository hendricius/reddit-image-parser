class Favorite < ActiveRecord::Base
  attr_accessible :image_id, :user_id
  belongs_to :user, :image
end