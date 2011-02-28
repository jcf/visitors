require 'redis'
require 'redis-namespace'

module Helpers
  class UnsupportedField < StandardError; end

  FIELDS = [:show, :search, :email, :website]
  SET_NAME = 'resource_ids'

  def redis
    @redis ||= Redis::Namespace.new(Visitors.config.redis_namespace,
                                    :redis => redis_connection)
  end

  def fields
    FIELDS
  end

  def assert_valid_field!(name)
    unless fields.include?(name)
      error_message = "Invalid field #{name.inspect}. Valid fields are #{fields.inspect}"
      raise UnsupportedField, error_message
    end
  end

  def stats_for(key)
    redis.hgetall(key)
  end

  def count
    redis.scard(SET_NAME)
  end

  def known_ids
    redis.smembers(SET_NAME)
  end

  def parse_date(date)
    date = date.to_s
    case date
    when /\d{4}/
      date
    when /\d{1,2}/
      Time.now.strftime("#{'%02d' % date}%y")
    else
      Time.now.strftime('%m%y')
    end
  end

  private

  def redis_connection
    @redis_connection ||= Redis.new(Visitors.config.redis_config)
  end
end
