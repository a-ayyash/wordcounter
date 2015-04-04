ENV['RACK_ENV'] = 'production'
require_relative './app.rb'

run Sinatra::Application

