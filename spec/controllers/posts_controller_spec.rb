require 'rails_helper'

RSpec.describe "Posts controller", type: :request do
  let :user do
    User.create(nickname: "spiderman", email: 'piter@parker.com',
                password: "password", password_confirmation: "password")
  end
  let :jwt do
    {
        "Authorization": "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
    }
  end

  context 'with valid params' do
    let :valid_params do
    {
        post: {
            title: "title",
            body: 'body',
            published_at: "2018-08-27T19:28:53.099Z"
        }
    }
  end

    # POST /api/v1/posts
    it "create new post" do
      expect { post "/api/v1/posts", params: valid_params, headers: jwt }.to change(Post, :count).by(+1)
      json = JSON.parse(response.body)
      expect(json).to include("title")
      expect(json).to include("body")
      expect(json).to include("published_at")
      expect(json).to include("author_nickname")
      expect(response).to have_http_status :ok
    end

    # GET /api/v1/posts/:id
    it 'show created post' do
      post "/api/v1/posts", params: valid_params, headers: jwt
      get "/api/v1/posts/#{Post.last.id}", headers: jwt
      json = JSON.parse(response.body)

      expect(json).to include("title")
      expect(json).to include("body")
      expect(json).to include("published_at")
      expect(json["author_nickname"]).to eql(user.nickname)
    end

    before :each do
      11.times do
        post "/api/v1/posts", params: valid_params, headers: jwt
      end
      get "/api/v1/posts", headers: jwt
    end

    # GET /api/v1/posts
    it 'show all post' do
      json = JSON.parse(response.body)
      expect(json.count).to eq 10
    end

    it 'check response headers' do
      expect(response.headers["posts_count"].to_i).to eq 11
      expect(response.headers["pages_count"].to_i).to eq 2
    end
  end

  context 'with invalid params' do
    let :invalid_params do
      {
          post: {
              title: "",
              body: ''
          }
      }
    end

    # POST /api/v1/posts
    it "create new post" do
      expect { post "/api/v1/posts", params: invalid_params, headers: jwt }.to_not change(Post, :count)
      expect(response.body).to match(/errors/)
      expect(response.body).to match(/can't be blank/)
    end

    # GET /api/v1/posts/:id
    it 'show created post' do
      post "/api/v1/posts", params: invalid_params, headers: jwt
      get "/api/v1/posts/10", headers: jwt
      expect(response.body).to match(/errors/)
      expect(response.body).to match(/Can't find comment with id 10/)
    end

    before :each do
      11.times do
        post "/api/v1/posts", params: invalid_params, headers: jwt
      end
      get "/api/v1/posts", headers: jwt
    end

    # GET /api/v1/posts
    it 'show all post' do
      json = JSON.parse(response.body)
      expect(json.count).to eq 0
    end

    it 'check response headers' do
      expect(response.headers["posts_count"].to_i).to eq 0
      expect(response.headers["pages_count"].to_i).to eq 1
    end
  end
end