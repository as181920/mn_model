require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"
require 'pg'
require 'active_record'
require 'yaml'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test*.rb"]
  t.verbose = true
end

desc "Run tests"
task default: :test

namespace :db do
  db_configurations = YAML::load(File.open('config/database.yml'))[ENV['db_env']||'development']

  desc "Migrate the db, can add env argument: database: rake db:migrate db_env=production"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_configurations)
    ActiveRecord::Migrator.migrate("db/migrate/")
  end

  desc "Create the db"
  task :create do
    admin_connection = db_configurations.merge({'database'=> 'postgres', 
                                                'schema_search_path'=> 'public'}) 
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(db_configurations.fetch('database'))
  end

  desc "drop the db"
  task :drop do
    admin_connection = db_configurations.merge({'database'=> 'postgres', 
                                                'schema_search_path'=> 'public'}) 
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(db_configurations.fetch('database'))
  end
end
