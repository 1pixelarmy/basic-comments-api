class Api::V1::RatingTypesController < ApplicationController
  respond_to :json

  def index
    rating_types = RatingType.all
    render json: rating_types
  end

  def show
    respond_with RatingType.find(params[:id])
  end
end
