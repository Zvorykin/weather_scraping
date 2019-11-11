require "rails_helper"

describe WeatherScraper::FetchCitiesWeatherService do
  describe "#call" do
    let(:cities) { [city] } # in bigger project we should use factory_bot gem
    let(:city) { "London" }
    let(:response_status) { 200 }
    let(:temp) { 303.3 }
    let(:country) { "GB" }

    let!(:stub) {
      stub_request(:get, Regexp.new(city)).to_return(
        status: response_status,
        body: {
          name: city,
          main: {
            temp: temp,
          },
          sys: {
            country: country,
          },
        }.to_json
      )
    }

    subject { described_class.call(cities) }
    let(:status) { subject.first }
    let(:payload) { subject.last }
    let(:first_city) { payload[:weather].first }

    it "should be successful" do
      expect(status).to be(:ok)
      expect(first_city).to include(
        temp: temp - 273.15, # it's not quite good to test using computed value but here we use physics constant
        city: city,
        country: country
      )
    end

    context "empty cities" do
      let(:cities) { [] }

      it { expect(status).to be(:unprocessable_entity) }
    end
  end
end
