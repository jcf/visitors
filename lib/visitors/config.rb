require 'yaml'

class Visitors::Config
  class MissingEnvironmentError < StandardError; end

  def self.load
    new.tap { |instance| instance.send(:define_methods_from_yaml) }
  end

  def fields
    yaml['fields'] && Array(yaml['fields']).map(&:to_sym)
  end

  def all
    return yaml[env] if yaml[env]
    raise MissingEnvironmentError, "#{env.inspect} environment not configured"
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

  def env
    ENV['RAILS_ENV'] || ENV['VISITORS_ENV'] || 'development'
  end

  def define_methods_from_yaml
    all.each do |key, value|
      self.class.send(:define_method, key) { value }
    end
  end
end
