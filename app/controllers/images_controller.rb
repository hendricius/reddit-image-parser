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
end
