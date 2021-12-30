class Forecast < ApplicationRecord
  has_many :forecast_details, dependent: :destroy

  scope :most_recent_first, -> { order(date: :asc) }
end
