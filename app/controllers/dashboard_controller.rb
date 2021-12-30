class DashboardController < ApplicationController
  NO_FORECASTS = 3

  def index
    set_forecasts
    set_joke
  end

  private

  def set_forecasts
    service = Metservice::LoadForecasts.call
    @forecasts = service.failure? ? [] : service.forecasts.slice(0, NO_FORECASTS)
  end

  def set_joke
    service = YoMomma::LoadJoke.call
    @joke = service.failure? ? nil : service.joke
  end
end
