class Image < ActiveRecord::Base
  attr_accessible :image, :author, :title, :external_id, :external_link
  mount_uploader :image, ImageUploader

  validates_uniqueness_of :external_id, :external_link
  validates :author, :title, :external_id, presence: true
  validate :image_or_external_link

  def get_feed
    return false if !$REDDIT_RSS
    begin
      Feedzirra::Feed.fetch_and_parse($REDDIT_RSS)
    rescue
      false
    end
  end

  def get_json
    return false if !$REDDIT_JSON
    begin
      # Use the maximum results Reddit API allows
      response = HTTParty.get "#{$REDDIT_JSON}?limit=100"
      response["data"]["children"].map{|entry| OpenStruct.new entry["data"]}
    rescue
      false
    end
  end

  def self.update_feed
    if $REDDIT_JSON
      img = Image.new
      img.update_json_feed
    else
      img = Image.new
      img.update_rss_feed
    end
  end

  def update_rss_feed
    get_feed.entries.each do |entry|
      # do not parse those that do not point to an image
      next if !entry.url.include?(".jpg")
      save_image(entry)
    end
  end

  def save_image(entry)
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
