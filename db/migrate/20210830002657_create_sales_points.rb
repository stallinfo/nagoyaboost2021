class CreateSalesPoints < ActiveRecord::Migration[6.1]
  def change
    create_table :sales_points do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.decimal :lat
      t.decimal :lon
      t.integer :capacity

      t.timestamps
    end
    add_index :sales_points, [:lat, :lon, :user_id]
  end
end
