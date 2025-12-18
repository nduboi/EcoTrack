class Expense < ApplicationRecord
  belongs_to :category
  validates :montant, presence: true, numericality: { greater_than: 0 }
end
