class User < ApplicationRecord
  # Necessary to authenticate.
  has_secure_password

  has_many :posts, inverse_of: :user, foreign_key: 'author_id'

  accepts_nested_attributes_for :posts

  validates_length_of       :password, maximum: 72, minimum: 8, allow_nil: true, allow_blank: false
  validates_confirmation_of :password, allow_nil: true, allow_blank: false

  # Make sure email and username are present and unique.
  validates_presence_of     :email
  validates_presence_of     :nickname
  validates_uniqueness_of   :email
  validates_uniqueness_of   :nickname

  before_validation {
    (self.email = self.email.to_s.downcase) && (self.nickname = self.nickname.to_s.downcase)
  }

end
