json.extract! transaction, :id, :posted_at, :description, :amount, :category_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
