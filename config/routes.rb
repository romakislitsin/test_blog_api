Rails.application.routes.draw do
  get '/avatar/:id' => 'users#avatar'
  post '/users/add_avatar' => 'users#add_avatar'
  resources :users, only: [:show]

  # Get login token from Knock
  post   'user_token'      => 'user_token#create'

  # User actions
  get    '/users/current'  => 'users#current'
  post   '/users/create'   => 'users#create'

  # Api actions
  scope :api do
    scope :v1 do
      resources :posts do
        resources :comments
      end
    end
  end
end