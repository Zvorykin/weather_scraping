# README

Simple pet project to practice site scraping.
This is web scraping pipeline that outputs the weather at destinations of flights leaving Vienna
airport hourly and on manual call using Rails, Selenium WebDriver, Sidekiq and Redis for caching.

Also there are simple Vue.js frontend to examine created data.

Requirements:
* Ruby 2.6.3
* Selenium and headless Chrome
* Redis
* `yarn` or `npm`

Run:
* `bundle install`
* `bundle exec rake db:create`
* `bundle exec rake db:migrate`
* `bundle exec rails -s`
* `sidekiq`
* `yarn && yarn run dev`
* go to `127.0.0.1:3000` and press 'Create notes' button

To run RSpec tests:
* `bundle exec rspec`
