class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :name, presence: true, length: { minimum: 1, maximum: 90 }
end
