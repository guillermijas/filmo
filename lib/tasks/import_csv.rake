namespace :import_csv do
  task import: :environment do

    CSV.foreach('lib/assets/films.csv', headers: true, row_sep: :auto, col_sep: ';') do |row|
      Film.create!(row.to_hash)
    end
  end
end