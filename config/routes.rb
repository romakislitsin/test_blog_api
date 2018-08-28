Rails.application.routes.draw do
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