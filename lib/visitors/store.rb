require 'redis'
require 'redis-namespace'

class Visitors::Store
  TTL = 24 * 60 * 60 # 24 hours

  attr_reader :namespace, :redis_config

  def initialize(options = {})
    @namespace    = options.delete(:namespace) || Visitors.config.redis_namespace
    @redis_config = options                    || Visitors.config.redis_config
  end

  def redis
    @redis ||= Redis.new(@redis_config)
  end

  def store
    @store ||= Redis::Namespace.new(@namespace, :redis => redis)
  end

  def find(document_id)
    store.hgetall document_id
  end

  def increment(document_id, field)
    Visitors.assert_valid_field!(field.to_sym)
    count = store.hincrby document_id, field.to_sym, 1
    store.expire document_id, TTL
    count
  end

  alias :incr :increment
end
