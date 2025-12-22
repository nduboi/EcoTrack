class Account < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :destroy
  has_many :revenues, dependent: :destroy

  validates :name, presence: true
  validates :balance, numericality: true
  def solde_actuel
    (balance || 0) + revenues.sum(:amount) - expenses.sum(:montant)
  end
end
