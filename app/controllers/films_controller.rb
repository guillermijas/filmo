class FilmsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_film, only: [:show, :edit, :update, :destroy]

  def index
    rated_films = Rating.where(user_id: current_user.id).pluck(:film_id)
    @films = Film.where(id: rated_films)
  end

  def show; end

  def new
    @film = Film.new
  end

  def edit; end

  def create
    @film = Film.new(film_params)

    respond_to do |format|
      if @film.save
        format.html { redirect_to @film, notice: 'Film was successfully created.' }
        format.json { render :show, status: :created, location: @film }
      else
        format.html { render :new }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @film.update(film_params)
        format.html { redirect_to @film, notice: 'Film was successfully updated.' }
        format.json { render :show, status: :ok, location: @film }
      else
        format.html { render :edit }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @film.destroy
    respond_to do |format|
      format.html { redirect_to films_url, notice: 'Film was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def recommend_film
    r_script = Rails.root.join('lib', 'assets', 'r_test.R')
    R.user_id = current_user.id
    R.eval(`cat #{r_script}`)
    recommended_films_ids = R.rec_ids
    ap recommended_films_ids
    @films = Film.where(id: recommended_films_ids)
  end

  private

  def set_film
    @film = Film.find(params[:id])
  end

  def film_params
    params.fetch(:film, {})
  end
end
