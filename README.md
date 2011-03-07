# Visitors

The visitors gem gives you a simple tracking system for use in your
Ruby-based web application. Anywhere in your app you can call…

    Visitors.increment(1, 'show')

…to increment a counter that corresponds to the resource with an
identifier of 1.

## Usage

First off install the gem

    gem install visitors

Next make sure you have Redis running and the config.yml file has the
right configuration settings to connect to your Redis instance.

    development:
      redis_namespace: visitors_development
      redis_config:
        host: localhost

You can specify which settings to use with a `VISITORS_ENV` variable.

Require the visitors gem in your Rails app via your Gemfile?

    gem 'visitors', '~> 0.0.2'

Now add `Visitors.increment(@resource.id, :show)` to a show action in
your application.

Launch a Vegas-powered Sinatra web console to see who's been visiting
your pages using `visitors web`.

## Warning

This code is likely to change a lot and probably shouldn't be used in
your beautiful production app because of this. Feel free to fork and use
the code but take bear in mind I make no committment to support,
maintain or even acknowledge the existence of this small cluster fluck.
