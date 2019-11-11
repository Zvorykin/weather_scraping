require "rails_helper"

# for production app it's better to stub WebDriver

describe WeatherScraper::FetchCitiesNamesService do
  describe "#call" do
    before(:all) { WebMock.disable! }
    after(:all) { WebMock.enable! }

    subject { described_class.call }
    let(:status) { subject.first }
    let(:payload) { subject.last }
    let(:cities) { payload[:cities_names] }

    it "should be successful" do
      expect(status).to be(:ok)
      expect(cities).to all(be_an(String))
    end
  end
end
