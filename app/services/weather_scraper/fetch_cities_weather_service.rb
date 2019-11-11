class WeatherScraper::FetchCitiesWeatherService < ApplicationService
  URL = "api.openweathermap.org/data/2.5/weather".freeze # we can use some gems like 'configus'
  # to store variables for different environments but this is pretty small application
  # and there will be only development environment
  APPID = (ENV["WEATHER_APPID"] || "a7283dcb8fe5d511b88915ed1122f384").freeze # my APPID just for development
  KELVINS = 273.15

  attr_reader :cities

  def initialize(cities)
    @cities = cities
  end

  def call
    weather = cities_weather
    # we can do some checks like this if we want to.
    return format_result(:unprocessable_entity, "Empty weather results") if weather.blank?

    format_result(:ok, {weather: weather})
  end

  private

  def cities_weather
    hydra = Typhoeus::Hydra.new(max_concurrency: 5)
    requests = cities.map do |city_name|
      request = fetch_weather(city_name)
      hydra.queue(request)
      request
    end
    hydra.run

    requests.map do |request|
      if request.response.response_code != 200
        Rails.logger.warn "Error response: #{request.response}"
        next
      end

      data = JSON.parse(request.response.body).deep_symbolize_keys
      parse_weather_data(data)
    end
      .compact
  end

  def fetch_weather(city_name)
    Typhoeus::Request.new(URL, params: {q: city_name, APPID: APPID})
  end

  def parse_weather_data(data)
    temp = data.dig(:main, :temp)
    country = data.dig(:sys, :country)
    city = data[:name]

    if temp.nil? || city.nil? || !%w[Float Fixnum].include?(temp.class.name)
      Rails.logger.warn "Cannot parse data: #{data}"
      return nil
    end

    {
      temp: temp - KELVINS,
      city: city,
      country: country,
    }
  end
end
