class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def index
    comments = Comment.all.page(params[:page]).per(params[:per_page])
    render json: comments, meta: pagination(comments, params[:per_page])
  end

  def show
    respond_with Comment.find(params[:id])
  end

  def create

    comment = Comment.new(:body => params[:comment][:body])
    comment.user_id = params[:user_id]

    if comment.save
      render json: comment, status: 201, location: [:api, comment]
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  def update
    comment = Comment.find(params[:id])
    if current_user.id == comment.user.id
      if comment.update(comment_params)
        render json: comment, status: 200, location: [:api, comment]
      else
        render json: { errors: comment.errors }, status: 422
      end
    else
      head 401
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    if current_user.id == comment.user.id
      comment.destroy
      head 204
    else
      head 401
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

end
