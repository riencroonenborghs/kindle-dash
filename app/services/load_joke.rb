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
    @joke = HTTParty.get(url, headers: headers)&.body
    errors.add(:base, "no data") unless joke
  rescue StandardError => e
    errors.add(:base, e.message)
  end

  def url
    raise "#url - implement me"
  end

  def headers
    { "Accept" => "text/plain" }
  end

  def parse_joke
    @joke    
  end
end
