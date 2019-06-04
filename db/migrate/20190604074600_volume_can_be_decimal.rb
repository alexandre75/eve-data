class VolumeCanBeDecimal < ActiveRecord::Migration[5.2]
  def change
    remove_column :histories, :modified_at
    change_column :histories, :median, :float
    change_column :histories, :quantity, :float
  end
end
