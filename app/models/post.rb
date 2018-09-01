class Post < ApplicationRecord
  belongs_to :user, foreign_key: 'author_id'
  has_many :comments, inverse_of: :post

  # Make sure email and username are present and unique.
  validates_presence_of     :title
  validates_presence_of     :body

  scope :by_published_date, -> { order(published_at: :desc) }
  scope :by_date, -> (start_date, end_date) { where('published_at >= ? AND published_at <= ?', start_date, end_date) }

  PER_PAGE = 10

  def set_time(time)
    self.published_at = time
  end
end
