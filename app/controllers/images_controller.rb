class ImagesController < ApplicationController
  respond_to :html

  def show
    @image = Image.find_by_id(params[:id])
    @next = @image.next
    @previous = @image.previous
    @title = @image.title
    @image_count = @image.user.images.count
  end

  def latest
    @image = Image.last
    @next = @image.next
    @previous = @image.previous
    @title = @image.title
    @image_count = @image.user.images.count
    render "show"
  end

  def index
    @user = User.find(params[:user_id])
    @image = @user.images.last
    @next = @image.next_from_user
    @previous = @image.previous_from_user
    @title = @image.title
    @image_count = @image.user.images.count
    render "show"
  end

  def user_image
    @user = User.find(params[:user_id])
    @image = Image.find(params[:image_id])
    @next = @image.next_from_user
    @previous = @image.previous_from_user
    @title = @image.title
    @image_count = @image.user.images.count
    render "show"
  end

  # Show the 10 top users who contributed most images.
  def top_users
    @top = Image.top_ten_users
  end

  def favorite
    @image = Image.find_by_id(params[:id])
    if Favorite.create_favorite_image_user(@image, current_user)
      respond_to do |format|
        format.html {redirect_to image_path(@image), notice: "Successfully favorited image."}
        format.js
      end
    else
      flash[:error] = "Could not save image"
    end
  end

  def unfavorite
    @image = Image.find_by_id(params[:id])
    if Favorite.delete_favorite_image_user(@image, current_user)
      respond_to do |format|
        format.html {redirect_to image_path(@image), notice: "Successfully unfavorited image."}
        format.js {render "favorite"}
      end
    else
      flash[:error] = "Could not unfavorite image"
    end
  end

end
