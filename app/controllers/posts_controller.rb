class PostsController < ApplicationController
  # Use Knock to make sure the current_user is authenticated before completing request.
  before_action :authenticate_user

  # Method to show all posts ordered by published date.
  def index
    per_page = params[:per_page] ? params[:per_page] : Post::PER_PAGE
    @posts = Post.by_published_date.paginate(page: params[:page], per_page: per_page)
    # Set count of posts and count of pages to query headers
    add_headers
    render json: @posts
  end

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
      render json: { errors: "Can't find comment with id #{params[:id]}" }
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :published_at, :author_id)
  end

  def add_headers
    response.set_header("posts_count", posts_count)
    response.set_header("pages_count", pages_count)
  end

  def posts_count
    Post.count.to_s
  end

  def pages_count
    @posts.total_pages
  end
end
