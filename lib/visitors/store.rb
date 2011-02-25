require 'redis'
require 'redis-namespace'

class Visitors::Store
  SET_NAME = 'resource_ids'
  TTL = 24 * 60 * 60 # 24 hours

  attr_reader :namespace, :redis_config

  def initialize(options = {})
    @namespace    = options.delete(:namespace) || Visitors.config.redis_namespace
    @redis_config = options                    || Visitors.config.redis_config
  end

  def redis
    @store ||= Redis::Namespace.new(@namespace, :redis => redis_connection)
  end

  def each
    resources.each do |resource_id|
      yield resource_id, store.hgetall(resource_id)
    end
  end

  def count
    redis.scard(SET_NAME)
  end

  def resources
    redis.smembers(SET_NAME)
  end

  def find(resource_id)
    redis.hgetall(resource_id)
  end

  def increment(resource_id, field)
    Visitors.assert_valid_field!(field.to_sym)
    push(resource_id, field)
  end

  alias :incr :increment

  private

  def redis_connection
    @redis_connection ||= Redis.new(@redis_config)
  end

  def push(resource_id, field)
    redis.sadd(SET_NAME, resource_id)
    redis.hincrby(resource_id, field, 1)
  end
end
