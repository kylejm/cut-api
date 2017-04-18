class CreateFilms < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    enable_extension 'uuid-ossp'

    create_table :films, id: :uuid do |t|
      t.citext      :title,                      null: false, index: { :unique => true }
      t.datetime    :theater_release_date
      t.integer     :running_time
      t.decimal     :rotten_tomatoes_score
      t.decimal     :external_user_score
      t.integer     :external_user_score_count
      t.integer     :external_user_want_to_watch_count
      t.string      :synopsis

      t.timestamps  null: false
    end
  end
end
