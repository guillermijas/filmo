class Film < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :tags, dependent: :destroy
end
