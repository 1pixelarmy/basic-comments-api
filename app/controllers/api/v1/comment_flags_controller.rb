class Api::V1::CommentFlagsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def create
    comment_flag_exists = CommentFlag.find_by_user_id_and_comment_id(params[:user_id], params[:comment_id])
    if comment_flag_exists
      render json: { errors: "Flag already set by this user on this comment" }, status: 400
    else
      comment = Comment.find(params[:comment_id])


      comment_flag = comment.comment_flags.build(comment_flag_params)
      comment_flag.user_id = params[:user_id]
      if comment_flag.save
        render json: comment_flag, status: 201
      else
        render json: { errors: comment_flag.errors }, status: 422
      end
    end
  end

  def destroy
    comment_flag = CommentFlag.find(params[:id])
    if current_user.id == comment_flag.user.id
      comment_flag.destroy
      head 204
    else
      head 401
    end
  end


  private

  def comment_flag_params
    params.require(:comment_flag).permit(:inappropriate, :user_id)
  end

end
