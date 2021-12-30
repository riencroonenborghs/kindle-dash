module YoMomma
  class LoadJoke < AppService
    attr_reader :joke

    def call
      load_joke
      return unless success?
      
      parse_joke
    end

    private

    attr_reader :data

    def load_joke
      @data = HTTParty.get(ENV["YO_MOMMA_API_URL"])
      errors.add(:base, "no data") unless data
    rescue StandardError => e
      errors.add(:base, e.message)
    end

    def parse_joke
      json_data = JSON.parse(data.body)&.deep_symbolize_keys!
      errors.add(:base, "no JSON data") and return unless json_data
      
      @joke = json_data[:joke]
    rescue StandardError => e
      errors.add(:base, e.message)
    end
  end
end
