require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'haml'
require File.expand_path('../../visitors', __FILE__)

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

set :root, File.expand_path('../../..', __FILE__)

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
