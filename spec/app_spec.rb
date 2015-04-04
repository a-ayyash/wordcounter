ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'
require 'rack/test'
require 'rspec'

include Rack::Test::Methods

def app
	Sinatra::Application
end


describe "root route" do	
	it "should be ok" do 
		get '/'
		expect(last_response).to be_ok
	end
end

describe "top words route" do	
	it "should be ok" do 
		get '/words/top'
		expect(last_response).to be_ok
	end
end

describe "count frequencies route" do	
	it "should be ok" do 
		post '/words/count'
		expect(last_response).to be_ok
	end
end

describe "clear frequencies route" do	
	it "should be ok" do 
		get '/words/clear'
		expect(last_response).to be_ok
	end
end
