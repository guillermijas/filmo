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
    redirect_to films_path
  end

  def update
    respond_to do |format|
      if @rating.update(film_params)
        format.html { redirect_to films_path, notice: 'Rating updated.' }
      else
        format.html { redirect_to films_path, alert: 'Invalid rating value' }
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

  def film_params
    params.require(:rating).permit(:rating_value)
  end
end