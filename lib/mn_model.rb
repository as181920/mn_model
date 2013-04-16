require "bundler/setup"
require "yaml"
require "pg"
require "active_record"

LIB_PATH = File.dirname(File.absolute_path(__FILE__))

DB_CONFIGURATIONS = YAML::load(File.read(File.join(LIB_PATH, '../config/database.yml')))
ActiveRecord::Base.establish_connection(DB_CONFIGURATIONS)
#puts Note.superclass.connection.current_database

Dir.glob(LIB_PATH + "/mn_model/*.rb").each {|f| require f}
#require "mn_model/version"
#require "mn_model/note"


module MnModel
  # Your code goes here...
end

