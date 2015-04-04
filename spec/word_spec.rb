ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../app.rb'

TXT = "ability aardwolf aaron aardvark aardvark abnormally ablaze ability aback aaron aardvark"

include Rack::Test::Methods

def app
	Sinatra::Application
end

before do
	Word.clearfrequencies
end

describe 'clearfrequencies()' do
	it "should zero all frequencies" do
		Word.clearfrequencies
		ds = Word.where('frequency > 0')
		expect(ds.empty?).to be true
	end
end

describe 'count()' do
	it "should return correct frequencies from text" do
		hash = Word.count(TXT)
		expect(hash['aardvark']).to eq(3) 
	end

	it "should handle empty text" do
		hash = Word.count("")
		expect(hash.empty?).to be true
	end
end


describe 'generateUpdatesFor()' do
	it "should handle empty parameter" do
		updates = Word.generateUpdatesFor({})
		expect(updates.empty?).to be true
	end

	it "should generate proper update statements" do
		words_freq = {}
		words_freq["first"] = 1
		words_freq["second"] = 2
		words_freq["third"] = 3

		updates = Word.generateUpdatesFor(words_freq)
		list_updates = updates.split(';')

		list_updates.each_with_index do |u, i|
			w = words_freq.keys[i]
			f = words_freq[w]
			true_update = Word.updateStatementTemplate(w, f)
			expect(true_update).to eq(u+';')
		end
	end
end

describe 'update()' do
	it "should update DB with correct frequencies" do 
		hash = Word.count(TXT)
		Word.update(TXT)
		Word.update(TXT)
		tops = Word.top(hash.count)

		identical = true

		JSON[tops].each_with_index do |r, i|
			w = r["word"]
			f = r["frequency"]

			if hash[w]*2 != f
				identical = false
				break
			end
		end

		expect(identical).to be true
	end
end

describe 'top()' do
	it "should return the correct top words" do
		hash = Word.count(TXT)
		Word.update(TXT)
		tops = Word.top(hash.count)

		identical = true
		topwords = []

		JSON[tops].each_with_index do |r, i|
			topwords[i] = r["word"]
		end

		if identical 
			identical = hash.keys.sort == topwords.sort
		end

		expect(identical).to be true
	end
end
