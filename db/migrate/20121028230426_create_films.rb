class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.string :netflix_id
      t.string :title
      t.integer :rating

      t.timestamps
    end
  end
end
