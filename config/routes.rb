Rails.application.routes.draw do
  # Get login token from Knock
  post   'user_token'      => 'user_token#create'

  # User actions
  get    '/users/current'  => 'users#current'
  post   '/users/create'   => 'users#create'
end
