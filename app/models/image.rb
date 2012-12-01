class Image < ActiveRecord::Base
  attr_accessible :image
  mount_uploader :image, ImageUploader

  def get_feed
    Feedzirra::Feed.fetch_and_parse($REDDIT[:rss_feed])
  end

  def parse_feed
    get_feed.entries.each do |entry|
      # do not parse those that do not point to an image
      next if !entry.url.include?(".jpg")
      save_image(entry)
    end
  end

  def save_image(entry)
    puts entry
    # entry.url contains the link to the feed.
   i = Image.new
   i.remote_image_url = entry.url
   i.save
  end
end
