require 'redis'
require 'redis-namespace'

class Visitors::Store
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
    Visitors.assert_valid_field!(field)
    store.hincrby document_id, field, 1
  end

  alias :incr :increment
end
