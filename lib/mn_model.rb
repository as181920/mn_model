require "bundler/setup"
require "pg"
require "active_record"

LIB_PATH = File.dirname(File.absolute_path(__FILE__))
Dir.glob(LIB_PATH + "/mn_model/*.rb").each {|f| require f}
#require "mn_model/version"
#require "mn_model/note"

db_configurations = YAML::load(File.read(File.join(LIB_PATH, '../config/database.yml')))
ActiveRecord::Base.establish_connection(db_configurations)
#puts Note.superclass.connection.current_database

module MnModel
  # Your code goes here...
end

