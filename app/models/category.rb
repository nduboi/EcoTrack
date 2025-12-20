class Category < ApplicationRecord
  has_many :expenses, dependent: :destroy
  validates :nom, presence: true
  belongs_to :user
end
