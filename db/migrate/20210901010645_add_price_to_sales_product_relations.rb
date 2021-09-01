class AddPriceToSalesProductRelations < ActiveRecord::Migration[6.1]
  def change
    add_column :sales_product_relations, :price, :decimal
  end
end
