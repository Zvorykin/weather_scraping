class WeatherScrapeWorker
  include Sidekiq::Worker

  def perform
    WeatherScraper::Service.call
  end
end
