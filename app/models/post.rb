class Post < ApplicationRecord
  belongs_to :user, foreign_key: 'author_id'

  # Make sure email and username are present and unique.
  validates_presence_of     :title
  validates_presence_of     :body

  scope :by_published_date, -> { order(published_at: :desc) }

  PER_PAGE = 10

  def set_time(time)
    self.published_at = time
  end
end
