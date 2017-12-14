class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rating, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to films_path
  end

  def show
    redirect_to films_path
  end

  def new
    redirect_to films_path
  end

  def edit
    redirect_to films_path
  end

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

  def destroy
    redirect_to films_path
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:rating_value)
  end
end