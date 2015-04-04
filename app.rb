require 'sinatra'
require 'sinatra/contrib'
require 'json'
require 'sequel'
require 'yaml'
require_relative './connection.rb'
require_relative './model/word.rb'

############################## Controller Actions ##############################
get '/' do
	"Hello"
end

get '/words/top', :provides => [:json] do
	Word.top(params[:limit])
end

post '/words/count' do
	Word.update(params[:text] || "")
end

get '/words/clear' do
	Word.clearfrequencies
end
