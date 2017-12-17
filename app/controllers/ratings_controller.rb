class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rating, only: :update

  def create
    Rating.create!(user_id: current_user.id, film_id: params[:rating][:film_id], rating_value: params[:rating][:rating_value])
    redirect_to request.referrer
  end

  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to request.referrer, notice: 'Rating updated.' }
      else
        format.html { redirect_to request.referrer, alert: 'Invalid rating value' }
      end
    end
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:rating_value)
  end
end