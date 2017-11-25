class InitDatabase < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true

    create_table :films do |t|
      t.string :title
      t.text :genres
      t.integer :imdb_id
      t.integer :tmdb_id

      t.timestamps null: false
    end

    create_table :ratings do |t|
      t.belongs_to :user, index: true
      t.belongs_to :film, index: true
      t.float :rating_value

      t.timestamps null: false
    end

    create_table :tags do |t|
      t.belongs_to :user, index: true
      t.belongs_to :film, index: true
      t.string :tag_name

      t.timestamps null: false
    end
  end
end
