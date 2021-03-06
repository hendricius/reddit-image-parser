class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :username, :external
  attr_accessor :total_images

  scope :external, where(external: true)
  scope :humans, where(external: false)

  has_many :images
  has_many :favorites

  validates_confirmation_of :password
  validates_presence_of :password, :password_confirmation, :on => :create
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username

  before_validation :ensure_external_not_nil, :on => :create

  def self.init_based_on_username(username)
    return false if !username || (username.length == 0)
    temppw = SecureRandom.hex(20)
    User.new(
      password: temppw,
      password_confirmation: temppw,
      email: "#{username}@dafuqrssparser.com",
      username: username,
      # Mark as being automatically generated
      external: true
    )
  end

  # Did the user favorite a specific image?
  def favorited?(test_image)
    favorites.where(image_id: test_image.id).any?
  end

  # if it is nil, set it to false.
  def ensure_external_not_nil
    if external.nil?
      self.external = false
    end
  end

end
