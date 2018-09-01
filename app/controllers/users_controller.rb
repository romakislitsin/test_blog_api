class UsersController < ApplicationController
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  # Use Knock to make sure the current_user is authenticated before completing request.
  before_action :authenticate_user,  only: [:current]
  before_action :find_user, only: [:avatar, :show, :add_avatar]

  def avatar
  end

  def show
  end

  def add_avatar
    if @user.update_attributes(avatar: params[:user][:avatar])
      redirect_to @user
    else
      render :avatar
    end
  end

  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  def current
    current_user.update!(last_login: Time.now)
    render json: current_user
  end

  # Method to create a new user using the safe params we setup.
  def create
    user = User.new(user_params)
    if user.save
      render json: {status: 200, msg: 'User was created.'}
    else
      render json: {errors: user.errors.messages}
    end
  end

  private
  # Setting up strict parameters for when we add account creation.
  def user_params
    params.permit(:id, :nickname, :email, :password, :password_confirmation, :avatar)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
