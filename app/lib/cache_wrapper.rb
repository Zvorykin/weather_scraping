# Using Redis cache here because it's easy and fast and just in case we do not need to persist data.
# If we need to investigate broken data after days and months after it's better to
# use ElasticSearch or another NoSQL DB.

module CacheWrapper
  class << self
    def app_keys(amount = 10)
      keys = []
      REDIS.scan_each(match: "weather_scraper:cities_names:*") { |key| keys << key }
      keys.reverse.take(amount)
    end

    def set(key, value, expiration_time = nil)
      if expiration_time.present?
        REDIS.setex(key, expiration_time, value)
      else
        REDIS.set(key, value)
      end
    end

    def get(key)
      JSON.parse(REDIS.get(key) || "nil")
    end
  end
end
