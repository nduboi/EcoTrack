class Revenue < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :name, :amount, :date, presence: true
end
