class Film < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :tags, dependent: :destroy

  def self.recommended_films(user_id, cluster = nil)
    if cluster.present?
      users = Cluster.where(cluster: cluster).pluck(:user_id)
    else
      user = User.find(user_id)
      users = Cluster.where(cluster: user.cluster.cluster).pluck(:user_id)
    end
    all_cluster_films = Film.joins(:ratings)
                            .where(ratings: { user_id: users })
                            .group(:film_id)
                            .having('AVG(ratings.rating_value) >= 4')
                            .pluck(:film_id)
    not_seen_films = all_cluster_films - Rating.where(user_id: user_id).pluck(:film_id)
    recommended = not_seen_films.shuffle.first(12)
    Film.where(id: recommended)
  end

  def real_imdb_id
    film_search_id = imdb_id.to_s

    case film_search_id.size
    when 3
      'tt0000' + film_search_id
    when 4
      'tt000' + film_search_id
    when 5
      'tt00' + film_search_id
    when 6
      'tt0' + film_search_id
    else
      'tt' + film_search_id
    end
  end
end
