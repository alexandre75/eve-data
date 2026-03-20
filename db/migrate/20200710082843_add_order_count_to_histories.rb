class AddOrderCountToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :order_count, :float
  end
end
