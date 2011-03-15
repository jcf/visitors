$:.push File.expand_path('..', __FILE__)
require 'bundler/setup'
require 'visitors/helpers'
require 'visitors/core_ext/hash'

module Visitors
  extend self

  autoload :Config,   'visitors/config'
  autoload :Resource, 'visitors/resource'

  def env
    ENV['RAILS_ENV'] || ENV['VISITORS_ENV'] || 'development'
  end

  def config
    @config ||= Config.load
  end

  def find(id)
    return if Visitors.config.disabled
    Resource.find(id)
  end

  def increment(id, field)
    return if Visitors.config.disabled
    Resource.new(id).increment(field)
  end
end
