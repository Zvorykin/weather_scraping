class WeatherScraper::SaveCitiesWeatherService < ApplicationService
  COUNTRIES_LOCALES = {
    %w[en us gb] => "en", # we should use it if we do not want to create tens of localizations for each country
  }.freeze
  DEFAULT_LOCALE = "en".freeze

  attr_reader :cities_weather

  def initialize(cities_weather)
    @cities_weather = cities_weather
  end

  def call
    cities_weather.each do |weather|
      temp, city, country = weather.values_at(:temp, :city, :country)

      note = note_with_locale(temp, locale(country || ""))

      # should we use transaction to create all records only if everything works fine?
      WeatherNote.create!(temp: temp, city: city, note: note)
    end

    format_result(:ok)
  end

  private

  def locale(country)
    find_locale_by_key(country) || find_locale_by_value(country) || DEFAULT_LOCALE
  end

  def find_locale_by_key(country)
    locale_key = COUNTRIES_LOCALES.keys.find { |locales_array| locales_array.include?(country) }
    COUNTRIES_LOCALES[locale_key]
  end

  def find_locale_by_value(country)
    translations.find { |item| item == country.to_sym }
  end

  def translations
    @translations ||= I18n.backend.send(:translations).keys
  end

  def note_with_locale(temp, locale)
    type = if temp > 25
      :hot
    elsif temp < 5
      :cold
    else
      :warm
    end

    I18n.with_locale(locale) { I18n.t type }
  end
end
