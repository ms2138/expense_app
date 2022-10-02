class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  scope :ordered, -> { order(created_at: :asc) }

  validates :name, presence: true, length: { minimum: 1, maximum: 90 }
end
