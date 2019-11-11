class WeatherNote < ApplicationRecord
  validates :city, :temp, presence: true
end
