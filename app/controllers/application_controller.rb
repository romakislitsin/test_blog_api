class ApplicationController < ActionController::API
  # Include Knock within your application.
  include Knock::Authenticable
end
