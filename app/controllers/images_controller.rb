class ImagesController < ApplicationController
  respond_to :html
  def index
    @images = Image.all
  end
end
