class WeatherController < ApplicationController
  def index
    notes = WeatherNote.limit(15).order(created_at: :desc)

    render json: {notes: notes}
  end

  def create_notes
    result = WeatherScraper::Service.call(params[:cache_timestamp])
    check_service_result(result)

    head :ok unless performed?
  end

  def caches
    caches = CacheWrapper.app_keys

    render json: {caches: caches}
  end
end
