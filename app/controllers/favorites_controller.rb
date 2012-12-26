class FavoritesController < ApplicationController
  respond_to :html

  def index
    @user = User.find(params[:user_id])
    @favorites = @user.favorites
  end

  def destroy
  end

  def create
  end

end
