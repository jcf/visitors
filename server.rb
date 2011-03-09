require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'haml'

$:.push File.expand_path(File.dirname(__FILE__))
require 'lib/visitors'

class Visitors::Server < Sinatra::Base
  MONTHS = %w[
    January
    February
    March
    April
    May
    June
    July
    August
    September
    October
    November
    December
  ]

  FIELDS = Visitors::Resource.fields

  dir = File.expand_path('..', __FILE__)

  set :views,  "#{dir}/views"
  set :public, "#{dir}/public"
  set :static, true

  get '/' do
    haml :home
  end

  post '/' do
    redirect params[:resource_id]
  end

  get '/:id' do
    @resource_id = params[:id]
    @visits = Visitors::Resource.find(params[:id])
    haml :show
  end

  get '/stylesheets/stats.css' do
    sass :stats
  end
end
