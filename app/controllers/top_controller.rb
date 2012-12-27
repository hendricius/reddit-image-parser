class TopController < ApplicationController
  respond_to :html

  # Show the 10 top users who contributed most images.
  def users
    @top = Image.top_ten_users
  end

  # Show the images that were most favorited
  def favorites
    @top = Favorite.top_ten_favorited
  end
end
