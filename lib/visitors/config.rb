require 'yaml'

class Visitors::Config
  class MissingEnvironmentError < StandardError; end

  DEFAULTS = {
    :redis_namespace => "visitors_#{Visitors.env}",
    :redis_connection => {:host => '127.0.0.1'},
    :disabled => false
  }

  def self.load
    new.tap { |instance| instance.send(:define_methods_from_yaml) }
  end

  def fields
    yaml['fields'] && Array(yaml['fields']).map(&:to_sym)
  end

  def all
    return yaml[Visitors.env] if yaml[Visitors.env]
    raise MissingEnvironmentError, "#{Visitors.env.inspect} environment not configured"
  end

  def inspect
    all.inspect
  end

  private

  if defined?(RAILS_ROOT)
    def yaml
      @yaml ||= YAML.load_file("#{RAILS_ROOT}/config/visitors.yml")
    end
  else
    def yaml
      @yaml ||= YAML.load_file(File.expand_path('../../../config.yml', __FILE__))
    end
  end

  def define_methods_from_yaml
    DEFAULTS.deep_merge(all).each do |key, value|
      self.class.send(:define_method, key) { value }
    end
  end
end
