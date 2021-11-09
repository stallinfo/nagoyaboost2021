class AddStockToSalesProductRelations < ActiveRecord::Migration[6.1]
  def change
    add_column :sales_product_relations, :stock, :integer
  end
end
