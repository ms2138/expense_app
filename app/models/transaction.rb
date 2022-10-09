class Transaction < ApplicationRecord
  belongs_to :category
  belongs_to :user

  scope :ordered, -> { order(posted_at: :asc) }

  def self.chart_data_for(user, month, year)
    all_data_for(user, month, year)
    .joins(:category)
    .group(:name).sum(:amount)
  end

  def self.all_data_for(user, month, year)
    where(posted_at: Time.new(year, month)..Time.new(year, month, Time.days_in_month(month)), user_id: user.id)
  end
end
