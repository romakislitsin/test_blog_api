class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :published_at, :author_nickname, :post_id

  def author_nickname
    object.user.nickname
  end
end