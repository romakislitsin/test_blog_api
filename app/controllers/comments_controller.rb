class CommentsController < ApplicationController
  before_action :authenticate_user,  only: [:index]
  before_action :find_post

  def index
    comments = @post.comments
    if comments.count > 0
      render json: comments
    else
      render json: { errors: "Current post doesn't have comments yet" }
    end
  end

  def create
    @comment = @post.comments.build(comment_params)

    if params[:published_at]
      @comment.set_time(params[:published_at])
    else
      @comment.set_time(Time.now)
    end
    @comment.user = current_user
    if @comment.save
      render json: @comment
    else
      render json: { errors: @comment.errors }
    end
  end

  def show
    if @comment = @post.comments.find_by(id: params[:id])
      render json: @comment
    else
      render json: { errors: "Can't find comment with id #{params[:id]}" }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :published_at)
  end

  def find_post
    @post = Post.find(params[:post_id])
  end
end
