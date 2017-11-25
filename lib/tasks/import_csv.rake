namespace :import_csv do
  task import_ratings: :environment do
    CSV.foreach('lib/assets/ratings.csv', headers: true, row_sep: :auto, col_sep: ',') do |row|
      Rating.create!(row.to_hash)
    end
  end

  task import_tags: :environment do
    CSV.foreach('lib/assets/tags.csv', headers: true, row_sep: :auto, col_sep: ',') do |row|
      Tag.create!(row.to_hash)
    end
  end
end