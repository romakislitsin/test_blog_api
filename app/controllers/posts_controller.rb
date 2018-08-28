class PostsController < ApplicationController
  # Use Knock to make sure the current_user is authenticated before completing request.
  before_action :authenticate_user

  # Method to create a new users post using the safe params we setup.
  def create
    @post = current_user.posts.build(post_params)

    if params.has_key?(:published_at)
      @post.set_time(params[:published_at])
    else
      @post.set_time(Time.now)
    end

    if @post.save
      render json: @post
    else
      render json: { errors: @post.errors }
    end
  end

  def show
    if @post = Post.find_by(id: params[:id])
      render json: @post
    else
      render json: { errors: "Can't find user with id #{params[:id]}" }
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :published_at, :author_id)
  end

end
