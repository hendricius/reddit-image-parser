class Image < ActiveRecord::Base
  attr_accessible :image, :author, :title, :external_id, :external_link
  mount_uploader :image, ImageUploader

  validates_uniqueness_of :external_id, :external_link
  validates :author, :title, :external_id, presence: true
  validate :image_or_external_link

  def self.get_feed
    Feedzirra::Feed.fetch_and_parse($RSS_FEED)
  end

  def self.update_feed
    Image.get_feed.entries.each do |entry|
      # do not parse those that do not point to an image
      next if !entry.url.include?(".jpg")
      Image.save_image(entry)
    end
  end

  def self.save_image(entry)
    # entry.url contains the link to the feed.
    i = Image.new
    if $STORE_REMOTE
      i.external_link = entry.url
    else
      i.remote_image_url = entry.url
    end
    i.author = entry.author
    i.title = entry.title
    i.external_id = entry.entry_id
    i.save
  end

  def build_image_link
    if image.url
      image.url
    else
      external_link
    end
  end

  private

  def image_or_external_link
    if !image && !external_link
      errors(:image, "Needs to have either image or external image")
      errors(:external_link, "Needs to have either image or external image")
    end
  end
end
