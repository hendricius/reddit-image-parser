class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :user_name

  has_many :images

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email, :user_name
end
