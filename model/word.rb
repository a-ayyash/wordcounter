require 'sequel'

class Word < Sequel::Model 
	def self.updateStatementTemplate(word, freq) 
		"UPDATE words SET frequency=frequency+" + freq.to_s + " WHERE word='"+word+"';"
	end

	def self.count(text)
		w_hash = {}

		text.split(' ').each do |w|
			unless w_hash[w]
				w_hash[w] = 0 
			end

			w_hash[w] = w_hash[w]+1
		end

		return w_hash
	end

	def self.generateUpdatesFor(words_frequencies)
		u = ""

		unless words_frequencies.empty?
			words_frequencies.each do |w, f|
				u = u + Word.updateStatementTemplate(w, f)
			end 
		end

		return u
	end

	def self.update(text)
		words_frequencies = Word.count(text)
		updates = Word.generateUpdatesFor(words_frequencies)
		DB.run(updates)
	end

	def self.top(cap=10)
		list = DB[:words].select(:word, :frequency).order(Sequel.desc(:frequency)).limit(cap)
		list.to_a.to_json
	end

	def self.clearfrequencies
		DB.run("UPDATE words SET frequency=0;")
	end
end
