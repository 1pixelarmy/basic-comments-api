class Api::V1::RatingsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def index
    comment = Comment.find(params[:comment_id])
    ratings = comment.ratings.page(params[:page]).per(params[:per_page])
    render json: ratings, meta: pagination(ratings, params[:per_page])
  end

  def show
    respond_with Rating.find(params[:id])
  end

  def create
    comment = Comment.find(params[:comment_id])
    rating = comment.ratings.build(rating_params)
    rating.rating_type_id = params[:rating_type_id]
    if rating.save
      render json: rating, status: 201, location: [:api, comment, rating]
    else
      render json: { errors: rating.errors }, status: 422
    end
  end

  def update
    rating = Rating.find(params[:id])
    if current_user.id == rating.comment.user.id
      if rating.update(rating_params)
        render json: rating, status: 200, location: [:api, rating.comment, rating]
      else
        render json: { errors: rating.errors }, status: 422
      end
    else
      head 401
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    if current_user.id == rating.comment.user.id
      rating.destroy
      head 204
    else
      head 401
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:value)
  end
end
