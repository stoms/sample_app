class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  attr_accessible :email, :name, :password, :password_confirmation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 50 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6, maximum: 16 }
  has_secure_password
end
