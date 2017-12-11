class FilmsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_film, only: [:show, :edit, :update, :destroy]

  def index
    @q = Film.ransack(params[:q])
    rated_films = Rating.where(user_id: current_user.id).pluck(:film_id)
    if params[:q].blank?
      @films = Film.where(id: rated_films)
    else
      @films = @q.result
    end
  end


  def show;
    film_search_id = @film.imdb_id
    @info = HTTParty.get("http://www.omdbapi.com/?i=tt0#{film_search_id}&apikey=6aca691")
  end

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
    @films = Film.first(5)
  end

  private

  def set_film
    @film = Film.find(params[:id])
  end

  def film_params
    params.fetch(:film, {})
  end
end
