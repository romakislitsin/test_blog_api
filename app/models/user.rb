class User < ApplicationRecord
  # Necessary to authenticate.
  has_secure_password

  has_one_attached :avatar

  has_many :posts, inverse_of: :user, foreign_key: 'author_id'
  has_many :comments, inverse_of: :user, foreign_key: 'author_id'

  accepts_nested_attributes_for :posts

  validates_length_of       :password, maximum: 72, minimum: 8, allow_nil: true, allow_blank: false
  validates_confirmation_of :password, allow_nil: true, allow_blank: false

  # Make sure email and username are present and unique.
  validates_presence_of     :email
  validates_presence_of     :nickname
  validates_uniqueness_of   :email
  validates_uniqueness_of   :nickname

  # Make sure avatar have image format and less than 3 MB
  validate :avatar_validation

  before_validation {
    (self.email = self.email.to_s.downcase) && (self.nickname = self.nickname.to_s.downcase)
  }

  def avatar_validation
    if avatar.attached?
      if avatar.blob.byte_size > 3145728 # 3 MB
        avatar.purge
        errors[:base] << 'Too big'
      elsif !avatar.blob.content_type.starts_with?('image/')
        avatar.purge
        errors[:base] << 'Wrong format'
      end
    end
  end

  def thumbnail
    self.avatar.variant(resize: "300x300")
  end
end
