$:.push File.expand_path('..', __FILE__)

module Visitors
  extend self

  autoload :Store,  'visitors/store'
  autoload :Config, 'visitors/config'
  autoload :Day,    'visitors/models'
  autoload :Month,  'visitors/models'
  autoload :Year,   'visitors/models'

  class UnsupportedField < StandardError; end

  FIELDS = [:show, :search, :email, :website]

  def fields
    FIELDS
  end

  def config
    @config ||= Config.load
  end

  def assert_valid_field!(name)
    unless fields.include?(name)
      error_message = "Invalid field #{name.inspect}. Valid fields are #{fields.inspect}"
      raise UnsupportedField, error_message
    end
  end
end
