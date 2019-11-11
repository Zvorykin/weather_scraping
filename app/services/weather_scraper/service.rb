class WeatherScraper::Service < ApplicationService
  attr_reader :cache_timestamp

  def initialize(cache_timestamp = nil)
    @cache_timestamp = cache_timestamp
  end

  def call
    if cache_timestamp.present?
      cities_names = CacheWrapper.get("weather_scraper:cities_names:#{cache_timestamp}") || []
    else
      cities_names = WeatherScraper::FetchCitiesNamesService.call.last[:cities_names]
      CacheWrapper.set(
        "weather_scraper:cities_names:#{Time.current.to_i}",
        cities_names,
        60 * 60
      )
    end

    weather_result = WeatherScraper::FetchCitiesWeatherService.call(cities_names)
    check_service_result(weather_result)

    save_result = WeatherScraper::SaveCitiesWeatherService.call(weather_result.last[:weather])
    check_service_result(save_result)
    save_result
  end
end
