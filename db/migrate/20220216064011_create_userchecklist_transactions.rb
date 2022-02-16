class CreateUserchecklistTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :userchecklist_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :userchecklist, null: false, foreign_key: true
      t.integer :value
      
      t.timestamps
    end
    add_index :userchecklist_transactions, [:userchecklist_id, :user_id]
  end
end
