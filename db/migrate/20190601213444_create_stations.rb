class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string :name
      t.integer :eveid
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
