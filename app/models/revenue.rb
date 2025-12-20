class Revenue < ApplicationRecord
  belongs_to :category
  belongs_to :user
  validates :name, :amount, :category, :date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :category, presence: true
end
