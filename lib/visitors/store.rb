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
    @redis ||= Redis::Namespace.new(@namespace, :redis => redis_connection)
  end

  def each
    resources.each do |resource_id|
      yield resource_id, store.hgetall(resource_id)
    end
  end

  def slice(count = 10)
    Hash[*slice_resource_ids(:srandmember, count).map { |resource_id|
      result = [resource_id, find(resource_id)]
      yield *result if block_given?
      result
    }.flatten]
  end

  # def slice!(count = 10)
  #   Hash[*slice_resource_ids(:spop, count).map { |resource_id|
  #     result = [resource_id, find(resource_id)]
  #     yield *result if block_given?
  #     redis.del(resource_id)
  #     result
  #   }.flatten]
  # end

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

  def slice_resource_ids(redis_method, count)
    slicer = lambda { redis.send(redis_method, SET_NAME) }
    ([slicer] * count).map(&:call).compact
  end

  def redis_connection
    @redis_connection ||= Redis.new(@redis_config)
  end

  def push(resource_id, field)
    redis.sadd(SET_NAME, resource_id)
    redis.hincrby(resource_id, field, 1)
  end
end
