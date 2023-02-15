module Fortunes
  class LoadJoke
    include Base

    attr_reader :joke

    def perform
      load_joke
    end

    private

    attr_reader :data

    def load_joke
      @joke = `#{ENV["FORTUNE_PATH"]} -s` # short
      errors.add(:base, "no data") unless joke
    rescue StandardError => e
      errors.add(:base, e.message)
    end
  end
end
