class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :film

  validates :rating_value, inclusion: [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
end
