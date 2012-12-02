class Image < ActiveRecord::Base
  attr_accessible :image, :author, :title, :external_id, :external_link
  mount_uploader :image, ImageUploader

  validates_uniqueness_of :external_id, :external_link
  validates :author, :title, :external_id, presence: true
  validate :image_or_external_link

  def get_rss
    return false if !$REDDIT_RSS
    begin
      filter_data(Feedzirra::Feed.fetch_and_parse($REDDIT_RSS).entries)
    rescue
      false
    end
  end

  def get_json
    return false if !$REDDIT_JSON
    begin
      # Use the maximum results Reddit API allows
      response = HTTParty.get "#{$REDDIT_JSON}?limit=100"
      response = response["data"]["children"].map{|entry| OpenStruct.new entry["data"]}
      filter_data(response)
    rescue
      false
    end
  end

  def filter_data(entries)
    data = filter_score_threshold(entries)
    filter_images(data)
  end

  # Filter the data with a specified threshold score.
  def filter_score_threshold(json_data)
    return if !json_data
    begin
      # Set a default threshold
      $REDDIT_THRESHOLD ? threshold = $REDDIT_THRESHOLD : threshold = 100
      json_data.select{|data| data.score.to_i >= threshold}
    rescue
      # Some feeds may not have a score, do not filter them.
      json_data
    end
  end

  # Filter only direct .jpg/png/gif links.
  def filter_images(entries)
    entries.select{|data| data.url.include?(".jpg") || data.url.include?(".png") || data.url.include?(".gif")}
  end

  def self.update_feed
    if $REDDIT_JSON
      img = Image.new
      img.update_json
    else
      img = Image.new
      img.update_rss_feed
    end
  end

  def update_rss_feed
    get_rss.entries.each do |entry|
      save_image(entry)
    end
  end

  def update_json
    get_json.each do |entry|
      save_image(entry)
    end
  end

  def save_image(entry)
    # entry.url contains the link to the feed.
    i = Image.new
    # If store remote is false, carrierwave will download the images and store
    # them locally.
    if $STORE_REMOTE
      i.external_link = entry.url
    else
      i.remote_image_url = entry.url
    end
    i.author = entry.author
    i.title = entry.title
    i.external_id = attempt_to_get_id(entry)
    i.save
  end

  # Some entries may not have an entry_id. others have an id.
  def attempt_to_get_id(entry)
    begin
      if entry.id
        entry.id
      else
        entry.entry_id
      end
    rescue
      nil
    end
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
