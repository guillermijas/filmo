# frozen_string_literal: true

class FilmsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ransack

  def index
    @q = Film.ransack(params[:q])
    if params[:q].blank?
      rated_films = Rating.where(user_id: current_user.id).pluck(:film_id)
      @films = Film.where(id: rated_films)
    else
      @films = @q.result
    end
  end

  def show
    @film = Film.find(params[:id])
    film_search_id = @film.imdb_id.to_s
    if film_search_id.size == 5
      film_search_id = 'tt00'+film_search_id
    elsif film_search_id.size == 6
      film_search_id = 'tt0'+film_search_id
    else
      film_search_id = 'tt'+film_search_id
    end
    @info = HTTParty.get("http://www.omdbapi.com/?i=#{film_search_id}&apikey=6aca691")
  end

  def new
    @film = Film.new
  end

  def top
    @films = if params[:genre] == 'All'
               Film.joins(:ratings)
                   .order('avg(ratings.rating_value) desc')
                   .group('ratings.film_id')
                   .having('COUNT(ratings.rating_value) > 30')
                   .limit(20)
             elsif %w[Action Adventure Animation Children Comedy Crime Documentary
                      Drama Fantasy Film-Noir Horror Musical Mystery Romance Sci-Fi
                      Thriller War Western].include?(params[:genre])
               genre = "%#{params[:genre]}%"
               Film.joins(:ratings)
                   .where('films.genres like ?', genre)
                   .order('avg(ratings.rating_value) desc')
                   .group('ratings.film_id')
                   .having('COUNT(ratings.rating_value) > 30')
                   .limit(20)
             end
    ap @films
  end

  def recommend_film
    # five_ratings = Rating.where(user_id: current_user.id).count >= 5
    # has_cluster = Cluster.find_by(user_id: current_user.id).present?
    # if five_ratings
    #   if has_cluster
    #     r_script = Rails.root.join('lib', 'assets', 'recommendation_cluster.R')
    #     cluster = Cluster.find_by(user_id: current_user.id)
    #     R.userId = current_user.id
    #     R.cluster = cluster.cluster
    #     R.eval(`cat #{r_script}`)
    #     film_ids = R.result
    #     ap film_ids
    #     @films = Film.where(id: film_ids)
    #   else
    #     respond_to do |f|
    #       f.html { redirect_to :index, alert: 'You must rate at least 5 films' }
    #     end
    #   end
    # else
    #   respond_to do |f|
    #     f.html { redirect_to :index, alert: 'You must rate at least 5 films' }
    #   end
    # end
    @films = Film.first(5)
  end

  private

  def set_ransack
    @q = Film.ransack(params[:q])
  end
end
