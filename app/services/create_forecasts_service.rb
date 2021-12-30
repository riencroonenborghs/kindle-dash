class CreateForecastsService < AppService
  def call
    load_metservice_forecasts
    return unless success?

    build_forecasts
    persist_forecasts
  end

  private

  attr_reader :metservice_forecasts, :forecasts

  def load_metservice_forecasts
    service = LoadMetserviceForecastsService.call
    if service.failure?
      errors.merge!(service.errors)
      return
    end

    @metservice_forecasts = service.forecasts
  end

  def build_forecasts
    dates = metservice_forecasts.map do |metservice_forecast|
      Date.parse(metservice_forecast[:date])
    end
    existing_forecasts_by_date = Forecast.where(date: dates).index_by(&:date)
    
    @forecasts = [].tap do |ret|
      metservice_forecasts.each do |metservice_forecast|
        date = Date.parse(metservice_forecast[:date])
        next if existing_forecasts_by_date[date]

        forecast = build_forecast(date, metservice_forecast)
        build_forecast_details(forecast, metservice_forecast)
        ret << forecast
      end
    end
  end

  def build_forecast(date, metservice_forecast)
    Forecast.new(
      date: date,
      condition: metservice_forecast[:condition],
      high_temp: metservice_forecast[:highTemp].to_f,
      low_temp: metservice_forecast[:lowTemp].to_f,
      issued_at: DateTime.parse(metservice_forecast[:issuedAt])
    )
  end

  def build_forecast_details(forecast, metservice_forecast)
    metservice_forecast[:forecasts].each do |ms_forecast|
      forecast.forecast_details.build(
        high_temp: ms_forecast[:highTemp].to_f,
        low_temp: ms_forecast[:lowTemp].to_f,
        sunrise: DateTime.parse(ms_forecast[:sunrise]),
        sunset: DateTime.parse(ms_forecast[:sunset]),
        details: ms_forecast[:statement],
        rain_1mm: ms_forecast[:rainFall1],
        rain_10mm: ms_forecast[:rainFall10]
      )
    end
  end

  def persist_forecasts
    forecasts.map(&:save!)
  end
end
