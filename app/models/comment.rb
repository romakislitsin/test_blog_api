class Comment < ApplicationRecord
  belongs_to :post, inverse_of: :comments
  belongs_to :user, foreign_key: 'author_id', inverse_of: :comments

  validates_presence_of :body

  def set_time(time)
    self.published_at = time
  end
end
