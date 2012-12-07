class ImagesController < ApplicationController
  respond_to :html

  def show
    @image = Image.find_by_id(params[:id])
    @higher = Image.find_by_id(@image.id + 1)
    @lower = Image.find_by_id(@image.id - 1)
    @title = @image.title
  end

  def latest
    @image = Image.last
    @higher = Image.find_by_id(@image.id + 1)
    @lower = Image.find_by_id(@image.id - 1)
    @title = @image.title
    render "show"
  end
end
