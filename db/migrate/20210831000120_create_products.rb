class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :status
      t.decimal :dprice
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, [:user_id, :name, :dprice]
  end
end
