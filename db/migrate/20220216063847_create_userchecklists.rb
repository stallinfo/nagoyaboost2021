class CreateUserchecklists < ActiveRecord::Migration[6.1]
  def change
    create_table :userchecklists do |t|
      t.string :content

      t.timestamps
    end
    add_index :userchecklists, [:id, :created_at]
  end
end
