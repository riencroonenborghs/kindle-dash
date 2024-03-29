module Metservice
  class Forecast < Struct.new(:date, :issued_at, :condition, :low_temp, :high_temp, :details, keyword_init: true); end
  class Detail < Struct.new(:low_temp, :high_temp, :sunrise, :sunset, :details, keyword_init: true); end

  class LoadForecasts < AppService
    attr_reader :forecasts

    def call
      load_data
      return unless success?

      parse_data
      return unless success?

      build_forecasts
    end

    private

    attr_reader :data, :json_data

    def load_data
      @data = HTTParty.get(ENV["METSERVICE_URL"])
      errors.add(:base, "no data") unless data
    rescue StandardError => e
      errors.add(:base, e.message)
    end

    def parse_data
      @json_data = JSON.parse(data.body)&.deep_symbolize_keys!
      errors.add(:base, "no JSON data") unless json_data
    rescue StandardError => e
      errors.add(:base, e.message)
    end

    def days
      modules = json_data.dig(:layout, :primary, :slots, :main, :modules)
      return [] unless modules

      modules[0].dig(:days)
    end

    def build_forecasts
      @forecasts = [].tap do |ret|
        days.each do |day|
          ret << build_forecast(day)
        end
      end
    end

    def build_forecast(day)
      Forecast.new(
        date: Date.parse(day[:date]),
        issued_at: DateTime.parse(day[:issuedAt]),
        condition: day[:condition],
        high_temp: day[:highTemp],
        low_temp: day[:lowTemp],
        details: build_details(day)
      )
    end
  
    def build_details(day)
      day[:forecasts].map do |detail|
        Detail.new(
          high_temp: detail[:highTemp],
          low_temp: detail[:lowTemp],
          sunrise: DateTime.parse(detail[:sunrise]),
          sunset: DateTime.parse(detail[:sunset]),
          details: detail[:statement]
        )
      end
    end
  end
end
