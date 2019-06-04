class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.integer :median
      t.integer :quantity
      t.integer :item
      t.references :region, foreign_key: true

      t.timestamps
    end
    add_index :histories, :item
  end
end
