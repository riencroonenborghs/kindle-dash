class DashboardController < ApplicationController
  def index
    @forecasts = Forecast.most_recent_first.limit(4)
    set_joke
  end

  private

  def set_joke
    service = YoMommaService.call
    return if service.failure?

    @joke = service.joke
  end

end
