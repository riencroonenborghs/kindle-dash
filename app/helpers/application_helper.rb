module ApplicationHelper
  def forecast_icon(forecast)
    base_icon(forecast.condition)
  end

  def scrub_character(joke)
    return joke unless joke
    joke = joke.gsub(/\\/, "|").gsub("\"","'").gsub("|n","").gsub("\n"," ")
    joke.unpack("U*").map{|c|c.chr}.join # UTF-8 convert
  end

  def breakdown_icon(breakdown)
    base_icon(breakdown)
  end

  def base_icon(icon)
    case icon
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
    when "windy"
      "wind"
    when "wind-rain"
      "cloud-drizzle"
    end
  end
end
