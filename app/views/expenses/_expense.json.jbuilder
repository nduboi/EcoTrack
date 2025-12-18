json.extract! expense, :id, :nom, :montant, :date, :category_id, :created_at, :updated_at
json.url expense_url(expense, format: :json)
