class Image < ActiveRecord::Base
  attr_accessible :image, :author, :title, :external_id, :external_link
  mount_uploader :image, ImageUploader

  belongs_to :user

  validates_uniqueness_of :external_id, :external_link
  validates :author, :title, :external_id, :user, presence: true
  validate :image_or_external_link

  before_validation :assign_user, :on => :create

  # Update all the feeds to fetch the latest images..
  def self.update_feed
    img = Image.new
    img.update_entries(Parser.new.images)
    img.update_entries(Parser.new.collections)
  end

  def self.top_ten_users
    self.top_users(10)
  end

  def self.top_users(amount)
    self.limit(amount).order("count_all desc").count(group: :user_id).map do |key, val|
      u = User.find(key)
      u.total_images = val
      u
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
    i.external_id = entry.id
    i.save
  end

  def build_image_link
    if image.url
      image.url
    else
      external_link
    end
  end

  # Return the next available record.
  def next
    self.class.where("id > ?", id).first
  end

  # Return a previous available record.
  def previous
    self.class.where("id < ?", id).last
  end

  def next_from_user
    self.class.where("id > ? AND user_id = ?", id, user_id).first
  end

  def previous_from_user
    self.class.where("id < ? AND user_id = ?", id, user_id).last
  end

  def assign_user
    existing = User.where(username: author)
    if !existing.empty?
      self.user = existing.first
    else
      create_user_for_image
    end
  end

  # Create a user for the image
  def create_user_for_image
    u = User.init_based_on_username(author)
    return false if !u.save
    self.user = u
  end

  private

  def image_or_external_link
    if !image && !external_link
      errors(:image, "Needs to have either image or external image")
      errors(:external_link, "Needs to have either image or external image")
    end
  end
end
