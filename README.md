# Visitors

The visitors gem gives you a simple tracking system for use in your
Ruby-based web application. Anywhere in your app you can call…

    Visitors.increment(1, :show)

…to increment a counter that corresponds to the resource with an
identifier of 1.

## Installation

First off install the gem

    gem install visitors

Require the visitors gem in your Rails app via your Gemfile.

    gem 'visitors', '~> 0.0.2'

Now add `Visitors.increment(@resource.id, :show)` to a show action in
your application.

## Configuration

When `RAILS_ROOT` is defined visitors will work based upon the
assumption your using it in combination with Rails. Make sure you have
Redis running and that you have a config.yml file in your Rails config
directory, similar to this:

    development:
      redis_namespace: visitors_development
      redis_config:
        host: localhost

    production:
      redis_namespace: visitors_production
      redis_config:
        host: redis-cluster.domain.com

Without `RAILS_ROOT` visitors will use a local development connection.
Not enough to be really useful! Here's the code that decides where to
load the config from:

    if defined?(RAILS_ROOT)
      def yaml
        @yaml ||= YAML.load_file("#{RAILS_ROOT}/config/visitors.yml")
      end
    else
      def yaml
        @yaml ||= YAML.load_file(File.expand_path('../../../config.yml', __FILE__))
      end
    end

The environment will be selected using the `RAILS_ENV`, the
`VISITORS_ENV` or default to `development`.

## Warning

This code is likely to change a lot and probably shouldn't be used in
your beautiful production app because of this. It's something I put
together quickly for use in work as writing all our activity to disk was
crippling servers.

Feel free to fork and use the code but take heed, I make no committment
to support, maintain or even acknowledge the existence of this small
cluster fuck.
