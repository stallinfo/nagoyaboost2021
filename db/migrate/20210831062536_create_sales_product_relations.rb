class CreateSalesProductRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :sales_product_relations do |t|
      t.references :sales_point, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
