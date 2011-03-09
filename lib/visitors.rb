$:.push File.expand_path('..', __FILE__)
require 'visitors/helpers'

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
    Resource.find(id)
  end

  def increment(id, field)
    Resource.new(id).increment(field)
  end
end
