require 'rails_helper'

RSpec.describe "Users controller", type: :request do
  let :valid_params do
    {
        nickname: "spiderman",
        email: 'piter@parker.com',
        password: "password",
        password_confirmation: "password"
    }
  end
  let :auth_params do
    {
        auth: {
            email: 'piter@parker.com',
            password: "password"
        }
    }
  end
  let :invalid_params do
    {
        nickname: "",
        email: '',
        password: "456",
        password_confirmation: "123"
    }
  end

  context "with valid params" do
    # POST /users/create
    it "create new user" do
      expect { post "/users/create", params: valid_params }.to change(User, :count).by(+1)
      expect(response.body).to match("{\"status\":200,\"msg\":\"User was created.\"}")
      expect(response).to have_http_status :ok
    end

    it 'auth created user' do
      # POST /user_token
      expect { post "/users/create", params: valid_params }.to change(User, :count).by(+1)
      post "/user_token", params: auth_params
      expect(response.body).to match(/jwt/)
      expect(response).to have_http_status :created
    end
  end

  context "with invalid params" do
    # POST /users/create
    it "create new user" do
      post "/users/create", params: invalid_params
      expect(response.body).to match(/errors/)
      expect(response.body).to match(/password/)
      expect(response.body).to match(/email/)
      expect(response.body).to match(/nickname/)
    end

    # POST /user_token
    it 'auth not created user' do
      post "/user_token", params: auth_params
      expect(response).to have_http_status :not_found
    end
  end
end