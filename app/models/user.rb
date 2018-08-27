class User < ApplicationRecord
  # Necessary to authenticate.
  has_secure_password

  validates_length_of       :password, maximum: 72, minimum: 8, allow_nil: true, allow_blank: false
  validates_confirmation_of :password, allow_nil: true, allow_blank: false

  before_validation {
    (self.email = self.email.to_s.downcase) && (self.nickname = self.nickname.to_s.downcase)
  }

  # Make sure email and username are present and unique.
  validates_presence_of     :email
  validates_presence_of     :nickname
  validates_uniqueness_of   :email
  validates_uniqueness_of   :nickname

  # This method gives us a simple call to check if a user has permission to modify.
  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

end
