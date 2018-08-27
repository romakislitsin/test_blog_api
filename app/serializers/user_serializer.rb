class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :nickname, :created_at, :updated_at, :last_login
end