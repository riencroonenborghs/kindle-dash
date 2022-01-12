module YoMomma
  class LoadJoke < ::LoadJoke
    private

    def url
      ENV["YO_MOMMA_API_URL"]
    end

    def headers
      {}
    end

    def parse_joke
      json_data = JSON.parse(joke)&.deep_symbolize_keys!
      errors.add(:base, "no JSON data") and return unless json_data
      
      @joke = json_data[:joke]
    rescue StandardError => e
      errors.add(:base, e.message)
    end
  end
end
