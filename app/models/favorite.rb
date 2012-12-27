class Favorite < ActiveRecord::Base
  attr_accessible :image_id, :user_id, :user, :image
  belongs_to :user
  belongs_to :image

  validates :image_id, uniqueness: {scope: :user_id}
  validates :user, :image, presence: true

  # Create a favorite image for the user
  def self.create_favorite_image_user(image, user)
    return if !image || !user
    Favorite.new(image: image, user: user).save
  end

  # Create a favorite image for the user
  def self.delete_favorite_image_user(image, user)
    return if !image || !user
    fav = self.where(image_id: image.id, user_id: user.id).first
    fav.destroy
    fav.destroyed?
  end

end
