class FavoritesController < ApplicationController
  respond_to :html

  def index
    @favorites = current_user.favorites.order("created_at desc")
  end

end
