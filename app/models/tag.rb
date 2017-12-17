# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :user
  belongs_to :film
end
