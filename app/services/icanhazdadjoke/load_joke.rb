module Icanhazdadjoke
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
      @joke = HTTParty.get(ENV["ICANHAZDADJOKE_API_URL"], headers: headers)&.body
      errors.add(:base, "no data") unless joke
    rescue StandardError => e
      errors.add(:base, e.message)
    end

    def headers
      { "Accept" => "text/plain" }
    end

    def parse_joke
      @joke = joke.gsub(/[\n\r]/, " ")
    end
  end
end
