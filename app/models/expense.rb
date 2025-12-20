class Expense < ApplicationRecord
  belongs_to :category
  belongs_to :user
  validates :montant, presence: true, numericality: { greater_than: 0 }
  validates :category, :date, presence: true
end
