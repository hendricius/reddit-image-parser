class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :username

  has_many :images

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email, :username

  def self.init_based_on_username(username)
    return false if !username || (username.length == 0)
    temppw = SecureRandom.hex(20)
    User.new(
      password: temppw,
      password_confirmation: temppw,
      email: "#{username}@dafuqrssparser.com",
      username: username
    )
  end

end
