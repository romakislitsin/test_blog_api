require 'rails_helper'

RSpec.describe "Comments controller", type: :request do
  let :user do
    User.create(nickname: "spiderman", email: 'piter@parker.com',
                password: "password", password_confirmation: "password")
  end
  let :users_post do
    Post.create(title: "title", body: 'body',
                published_at: "2018-08-27T19:28:53.099Z", author_id: user.id)
  end
  let :jwt do
    {
        "Authorization": "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
    }
  end
  let :valid_params do
    {
        comment: {
            body: "body",
            published_at: "2018-08-27T19:28:53.099Z"
        }
    }
  end
  let :invalid_params do
    {
        comment: {
            body: ''
        }
    }
  end

  context 'with valid params' do
    # POST /api/v1/posts/:post_id/comments
    it "create new comment" do
      post "/api/v1/posts/#{users_post.id}/comments.json", params: valid_params, headers: jwt
      json = JSON.parse(response.body)
      expect(json).to include("body")
      expect(json).to include("post_id")
      expect(json).to include("author_nickname")
      expect(response).to have_http_status :ok
    end

    # GET /api/v1/posts/:post_id/comment/id
    it 'show created comment' do
      post "/api/v1/posts/#{users_post.id}/comments.json", params: valid_params, headers: jwt
      get "/api/v1/posts/#{users_post.id}/comments/#{Comment.last.id}", headers: jwt
      json = JSON.parse(response.body)

      expect(json).to include("body")
      expect(json).to include("published_at")
      expect(json["post_id"]).to eql(users_post.id)
      expect(json["author_nickname"]).to eql(user.nickname)
    end

    before :each do
      3.times do
        post "/api/v1/posts/#{users_post.id}/comments.json", params: valid_params, headers: jwt
      end
      get "/api/v1/posts/#{users_post.id}/comments", headers: jwt
    end

    # GET /api/v1/posts/:post_id/comments
    it 'show all comments' do
      json = JSON.parse(response.body)
      expect(json.count).to eq 3
    end
  end

  context 'with invalid params' do
    # POST /api/v1/posts/:post_id/comments
    it "create new comment" do
      post "/api/v1/posts/#{users_post.id}/comments.json", params: invalid_params, headers: jwt
      expect(response.body).to match(/errors/)
      expect(response.body).to match(/can't be blank/)
    end

    # GET /api/v1/posts/:post_id/comment/id
    it 'show created comment' do
      post "/api/v1/posts/#{users_post.id}/comments.json", params: valid_params, headers: jwt
      get "/api/v1/posts/#{users_post.id}/comments/10", headers: jwt
      expect(response.body).to match(/errors/)
      expect(response.body).to match(/Can't find comment with id 10/)
    end

    before :each do
      3.times do
        post "/api/v1/posts/#{users_post.id}/comments.json", params: invalid_params, headers: jwt
      end
      get "/api/v1/posts/#{users_post.id}/comments", headers: jwt
    end

    # GET /api/v1/posts/:post_id/comments
    it 'show all comments' do
      json = JSON.parse(response.body)
      expect(json.count).to_not eq 3
    end
  end
end