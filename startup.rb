require 'yaml'

def checkForGemfileLock
	current_directory = File.dirname(File.expand_path(__FILE__)) 
	found = false

	Dir.foreach(current_directory) do |f|
		if f == "Gemfile.lock"
			found = true
		end
	end

	if !found 
		puts "Looks like you didn't run 'bundle install' in this directory yet" 
		puts "trying to run it for you"
		system 'bundle install'
		puts "Alright, looks like gems are in order now"
	end

	require 'sequel'
end

def getDatabaseAttributes
	puts "So far I can talk to PostgreSQL" 
	puts "We are going to need a main DB and a test DB" 
	puts "So, do we have a main and test DBs to connect to? [Yn]" 
	a = gets.chomp

	if (a.capitalize == "Y")
		### Main Database ###
		puts "Okay so what is the main database name?"
		db_name = gets.chomp
		puts "Its username"
		db_username = gets.chomp
		puts "Its password, enter if empty"
		db_pwd = gets.chomp
		puts "and finally, where is it located? 'press enter for default: localhost'"
		db_host = gets.chomp
		db_host = "localhost" if db_host.empty?

		### Test Database ###
		puts "Great, now what is the test database name?"
		test_db_name = gets.chomp
		puts "Its username"
		test_db_username = gets.chomp
		puts "Its password"
		test_db_pwd = gets.chomp
		puts "and finally, where is it located? 'press enter for default: localhost'"
		test_db_host = gets.chomp
		test_db_host = "localhost" if db_host.empty?

		puts "lets see if we can connect to it"
		begin 
			dB = Sequel.postgres(db_name, :user => db_username, :password => db_pwd, :host => db_host)
			test_dB = Sequel.postgres(test_db_name, :user => test_db_username, :password => test_db_pwd, :host => test_db_host)
			puts test_dB.test_connection
			configs = {}
			main_config = {}
			test_config = {}

			main_config['username'] = db_username
			main_config['database'] = db_name 
			main_config['password'] = db_pwd
			main_config['host'] = db_host

			test_config['username'] = test_db_username
			test_config['database'] = test_db_name 
			test_config['password'] = test_db_pwd
			test_config['host'] = test_db_host

			configs['production'] = main_config
			configs['test'] = test_config

			puts "Connected, now populating tables, This may take a bit"

			unless dB.tables.include?("words")
				Sequel.extension :migration
				Sequel::Migrator.apply(dB, "db/migrations/")
			end
			
			unless dB.tables.include?("words")
				Sequel.extension :migration
				Sequel::Migrator.apply(test_dB, "db/migrations/")
			end

			return configs, dB, test_dB
		rescue => e
			puts "Something went wrong"
			puts e
		end
	else
		puts "Okay, BYE!!"
	end
end

def main
	puts "hello there, so you want to count word frequencies"
	puts "this web app is going to run on http://0.0.0.0:9292"

	puts "Checking for status of gems in the system"
	checkForGemfileLock

	db_configs, db, test_db = getDatabaseAttributes

	if db_configs

		File.open('./config/config.yml', 'w') do |file| 
			file.write(db_configs.to_yaml)
		end

		#check for table and populate it if needed
		
		words = db[:words]

		if words.empty? 
			File.readlines('./clean_words').each do |w|
				words.insert(:word => w.chomp, :frequency => 0)
			end
		end

		words_test = test_db[:words]

		if words_test.empty? 
			File.readlines('./short_clean_words').each do |w|
				words_test.insert(:word => w.chomp, :frequency => 0)
			end
		end

		system './wordcounter start'
		puts "Enjoy :D"
	end
end

#Starting up
main
