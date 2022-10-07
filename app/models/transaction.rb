class Transaction < ApplicationRecord
  belongs_to :category
  belongs_to :user

  scope :ordered, -> { order(posted_at: :asc) }

  def self.chart_data_for_month(month, year)
    select("transactions.amount, categories.name")
    .where(posted_at: Time.new(year, month)..Time.new(year, month, Time.days_in_month(month)))
    .joins(:category)
    .group(:name).sum(:amount)
  end

  def self.current_month(month, year)
    where(posted_at: Time.new(year, month)..Time.new(year, month, Time.days_in_month(month)))
  end
end
