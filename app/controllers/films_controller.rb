# frozen_string_literal: true

class FilmsController < ApplicationController
  before_action :authenticate_user!, only: [:recommend_film]
  before_action :set_ransack

  def index
    if current_user.blank?
      @films = if params[:q].blank?
                 []
               else
                 @q.result
               end
    else
      if params[:q].blank?
        rated_films = Rating.where(user_id: current_user.id).pluck(:film_id)
        @films = Film.where(id: rated_films)
      else
        @films = @q.result
      end
    end
  end

  def show
    @film = Film.find(params[:id])
    @info = HTTParty.get("http://www.omdbapi.com/?i=#{@film.real_imdb_id}&apikey=6aca691")
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
                   .limit(5)
             end
  end

  def recommend_film
    rated_films = Rating.where(user_id: current_user.id)
    five_ratings = rated_films.count >= 5
    has_cluster = Cluster.find_by(user_id: current_user.id).present?
    if five_ratings
      if has_cluster
        @films = Film.recommended_films(current_user.id)
      else
        r_script = Rails.root.join('lib', 'assets', 'recommendation_tree.R')
        R.userId = current_user.id
        R.eval(`cat #{r_script}`)
        cluster = R.cluster_id
        @films = Film.recommended_films(current_user.id, cluster)
      end
    else
      respond_to do |f|
        f.html { redirect_to films_path, alert: 'You must rate at least 5 films' }
      end
    end
  end

  private

  def set_ransack
    @q = Film.ransack(params[:q])
  end
end
