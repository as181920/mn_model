require "bundler/setup"
require "yaml"
require "pg"
require "active_record"
require "logger"

LIB_PATH = File.dirname(File.absolute_path(__FILE__))

DB_CONFIGURATIONS_ALLENV = YAML::load(File.read(File.join(LIB_PATH, '../config/database.yml')))
if defined?(Goliath) and defined?(Goliath.env)
  DB_CONFIGURATIONS = DB_CONFIGURATIONS_ALLENV[Goliath.env.to_s]
else
  DB_CONFIGURATIONS = DB_CONFIGURATIONS_ALLENV["development"]
end
ActiveRecord::Base.establish_connection(DB_CONFIGURATIONS)
#puts Note.superclass.connection.current_database
ActiveRecord::Base.logger = Logger.new(File.join(LIB_PATH, '../log/db.log'), 'weekly')

Dir.glob(LIB_PATH + "/mn_model/*.rb").each {|f| require f}
#require "mn_model/version"
#require "mn_model/note"


module MnModel
  # Your code goes here...
end

