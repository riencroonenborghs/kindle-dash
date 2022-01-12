module Icanhazdadjoke
  class LoadJoke < ::LoadJoke
    private

    def url
      ENV["ICANHAZDADJOKE_API_URL"]
    end
  end
end
