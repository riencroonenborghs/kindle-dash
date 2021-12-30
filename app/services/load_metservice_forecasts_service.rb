class LoadMetserviceForecastsService < AppService
  def call
    load_data
    return unless success?

    parse_data
  end

  def forecasts
    modules = json_data.dig(:layout, :primary, :slots, :main, :modules)
    return [] unless modules

    modules[0].dig(:days)
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
end
