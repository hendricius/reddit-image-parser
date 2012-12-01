class ImagesController < ApplicationController
  respond_to :html

  def show
    @image = Image.find_by_id(params[:id])
    @higher = Image.find_by_id(@image.id + 1)
    @lower = Image.find_by_id(@image.id - 1)
  end

  def latest
    @image = Image.last
    redirect_to @image
  end
end
