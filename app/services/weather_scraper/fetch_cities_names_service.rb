require "selenium-webdriver"

class WeatherScraper::FetchCitiesNamesService < ApplicationService
  URL = "https://www.viennaairport.com/passagiere/ankunft__abflug/abfluege".freeze
  CITY_NAME_REGEXP = /^(?<city>[\w ]*)/.freeze

  def call
    format_result(:ok, {cities_names: cities_names})
  end

  private

  def cities_names
    # we can just get json data using link https://www.viennaairport.com/jart/prj3/va/data/flights/out.json
    # but there is no challenge. Let's assume that we never saw that link and scrape the whole page

    options = Selenium::WebDriver::Chrome::Options.new(args: ["headless"])
    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver.get(URL)

    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(css: ".details__info") }

    scrape_city_names(driver)
  end

  def scrape_city_names(driver)
    driver.find_elements(css: ".details__info:nth-child(2) div:last-child span:nth-child(2)")
      .each_with_object([]) { |element, acc|
        matches = match_city_name(element.attribute("innerText"))

        acc << matches[:city] if matches.present?
      }
      .uniq # we can check if city name already presents in array before adding it
    # but it's more performant to filter out doubles. Who knows how much data we've got
  end

  def match_city_name(string)
    I18n.transliterate(string).match(CITY_NAME_REGEXP)
  end
end
