class ImagesController < ApplicationController
  respond_to :html

  def show
    @image = Image.find_by_id(params[:id])
  end

  def latest
    @image = Image.last
    redirect_to @image
  end
end
