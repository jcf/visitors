require 'redis'
require 'redis-namespace'

class Visitors::Store
  ID_STORE_NAMESPACE = 'document_ids'
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

  def each
    documents.each do |document_id|
      yield document_id, store.hgetall(document_id)
    end
  end

  def documents
    store.smembers(ID_STORE_NAMESPACE)
  end

  def find(document_id)
    store.hgetall(document_id)
  end

  def increment(document_id, field)
    Visitors.assert_valid_field!(field.to_sym)
    push(document_id, field)
  end

  alias :incr :increment

  private

  def push(document_id, field)
    store.sadd(ID_STORE_NAMESPACE, document_id)
    store.hincrby(document_id, field, 1)
  end
end
