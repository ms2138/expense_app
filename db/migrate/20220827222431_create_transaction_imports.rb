class CreateTransactionImports < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_imports do |t|

      t.timestamps
    end
  end
end
