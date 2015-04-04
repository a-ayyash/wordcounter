DB_CONFIG = YAML::load(File.open('config/config.yml'))
ENV_DB_CONFIG = DB_CONFIG['production'] 

db_name = ENV_DB_CONFIG['database']
username = ENV_DB_CONFIG['username']
password = ENV_DB_CONFIG['password']
host = ENV_DB_CONFIG['host']

ENV['DATABASE_URL'] = "postgres://#{username}:#{password}@#{host}/#{db_name}"

DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
