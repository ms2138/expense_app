class Transaction < ApplicationRecord
  belongs_to :category
  belongs_to :user

  def self.chart_data_for_month(month)
    toDate = toDate(month)
    select("transactions.amount, categories.name")
    .where(posted_at: fromDate..toDate)
    .joins(:category)
    .group(:name).sum(:amount)
  end

  def self.current_month(month)
    toDate = toDate(month)
    where(posted_at: fromDate..toDate)
  end

  private
  
  def toDate(month)
    year = Time.now.year
    fromDate = Time.new(year, month)
    toDate = Time.new(year, month, fromDate.end_of_month.day)
  end
end
