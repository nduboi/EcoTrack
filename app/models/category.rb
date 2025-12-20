class Category < ApplicationRecord
  has_many :expenses, dependent: :destroy
  has_many :revenues, dependent: :destroy
  validates :nom, presence: true
  belongs_to :user
end
