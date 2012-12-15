class ImagesController < ApplicationController
  respond_to :html

  def show
    @image = Image.find_by_id(params[:id])
    @higher = @image.next
    @lower = @image.previous
    @title = @image.title
  end

  def latest
    @image = Image.last
    @higher = @image.next
    @lower = @image.previous
    @title = @image.title
    render "show"
  end
end
