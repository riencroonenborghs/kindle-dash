class DashboardController < ApplicationController
  NO_FORECASTS = 3

  def index
    set_forecasts
    set_joke
    pp @joke
  end

  private

  def set_forecasts
    service = Metservice::LoadForecasts.call
    @forecasts = service.failure? ? [] : service.forecasts.slice(0, NO_FORECASTS)
  end

  def set_joke
    case rand(0..3)
    when 0
      set_yo_momma_joke
    when 1
      set_icanhazdadjoke_joke
    else
      set_fortunes_joke
    end
  end

  def set_yo_momma_joke
    service = YoMomma::LoadJoke.call
    @joke = service.failure? ? nil : service.joke
  end

  def set_icanhazdadjoke_joke
    service = Icanhazdadjoke::LoadJoke.call
    @joke = service.failure? ? nil : service.joke
  end

  def set_fortunes_joke
    service = Fortunes::LoadJoke.call
    @joke = service.failure? ? nil : service.joke
  end
end
