require "rails_helper"

describe WeatherScraper::Service do
  describe "#call" do
    let(:cache_timestamp) { nil }

    subject { described_class.call(cache_timestamp) }

    before do
      allow(WeatherScraper::FetchCitiesWeatherService).to receive(:call)
        .and_return([
          :ok,
          weather:
            [
              {
                temp: 30,
                city: "London",
                country: "GB",
              },
            ],
        ])

      @names_service = class_double("WeatherScraper::FetchCitiesNamesService").as_stubbed_const
    end

    it "should not call FetchCitiesNamesService" do
      allow(@names_service).to receive(:call).and_return([:ok, cities_names: ["London"]])

      subject
    end

    context "got timestamp" do
      let(:cache_timestamp) { Time.current.to_i }

      it "should not call FetchCitiesNamesService" do
        subject

        expect(@names_service).not_to receive(:call)
      end
    end
  end
end
