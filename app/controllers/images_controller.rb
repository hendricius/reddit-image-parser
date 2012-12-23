class ImagesController < ApplicationController
  respond_to :html

  def show
    @image = Image.find_by_id(params[:id])
    @next = @image.next
    @previous = @image.previous
    @title = @image.title
  end

  def latest
    @image = Image.last
    @next = @image.next
    @previous = @image.previous
    @title = @image.title
    render "show"
  end

  def index
    @user = User.find(params[:user_id])
    @image = @user.images.last
    @next = @image.next_from_user
    @previous = @image.previous_from_user
    @title = @image.title
    render "show"
  end

  def user_image
    @user = User.find(params[:user_id])
    @image = Image.find(params[:image_id])
    @next = @image.next_from_user
    @previous = @image.previous_from_user
    @title = @image.title
    render "show"
  end

end
