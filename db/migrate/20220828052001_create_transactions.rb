class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.date :posted_at
      t.string :description
      t.decimal :amount
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
