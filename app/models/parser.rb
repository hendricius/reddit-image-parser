class Parser
  require 'open-uri'
  # Responsibile for parsing images.
  attr_accessor :data

  def get_api_data
    if $REDDIT_JSON
      self.data = get_json
    else
      self.data = get_rss
      # convert to be in proper format.
      convert_rss_format
    end
  end

  def convert_rss_format
    data.each do |entry|
      entry.id = entry.entry_id
    end
  end

  def get_rss
    return false if !$REDDIT_RSS
    begin
      Feedzirra::Feed.fetch_and_parse($REDDIT_RSS).entries
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

  def images
    begin
      get_api_data
      filter_score_threshold
      filter_images
      data
    rescue
      nil
    end
  end

  def collections
    begin
      get_api_data
      filter_score_threshold
      filter_collections
      filter_imgur
      convert_to_include_collection_images
      data
    rescue
      nil
    end
  end

  # Filter the data with a specified threshold score.
  def filter_score_threshold
    # Set a default threshold
    $REDDIT_THRESHOLD ? threshold = $REDDIT_THRESHOLD : threshold = 100
    self.data = data.select{|data_entry| data_entry.score.to_i >= threshold}
  end

  # Filter only direct .jpg/png/gif links.
  def filter_images
    self.data = data.select{|entry| entry.url.include?(".jpg") || entry.url.include?(".png") || entry.url.include?(".gif")}
  end

  # Ensure the data is in the correct for collections.
  def filter_collections
    self.data = data.reject{|entry| entry.url.include?(".jpg") || entry.url.include?(".png") || entry.url.include?(".gif")}
  end

  # Filter to ensure imgur is present
  def filter_imgur
    self.data = data.select{|entry| entry.url.include?("imgur")}
  end

  def convert_to_include_collection_images
    new_entries = []
    data.each do |entry|
      scraped_images = scrape_images_imgur(entry.url)
      # If there are no images, go for the next one.
      next if !scraped_images || scraped_images.empty?
      scraped_images.each_with_index do |url, index|
        new_entry = entry.dup
        new_entry.url = url
        new_entry.title = "#{new_entry.title} - Image: #{index + 1}"
        new_entry.id = "#{entry.id}-#{index}"
        new_entries.push(new_entry)
      end
    end
    self.data = new_entries.reverse
  end

  # Gets the image for an imgur url
  def scrape_images_imgur(url)
    return if !url.include?("imgur")
    doc = Nokogiri::HTML(open(url))
    # Image location on imgur inside image-container div
    doc.search('#image-container img').map{|elem| elem["data-src"]}
  end
end
