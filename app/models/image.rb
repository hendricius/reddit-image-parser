class Image < ActiveRecord::Base
  attr_accessible :image
  mount_uploader :image, ImageUploader
end
