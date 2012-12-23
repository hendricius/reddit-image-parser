module ImagesHelper
  def user_image_or_image_path(image, user)
    if !user
      image_path(image) if !user
    else
      user_image_collection_path(user, image)
    end
  end
end
