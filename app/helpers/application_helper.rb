module ApplicationHelper
  def forecast_icon(forecast)
    case forecast.condition
    when "fine"
      "sun"
    when "few-showers"
      "cloud-drizzle"
    when "partly-cloudy"
      "cloud-sun"
    when "cloudy"
      "cloudy"
    when "rain"
      "cloud-rain-fill"
    when "showers"
      "cloud-rain"
    when "drizzle"
      "cloud-drizzle"
    end
  end
end
