# frozen_string_literal: true

class CreateClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :cluster

      t.timestamps
    end
  end
end
