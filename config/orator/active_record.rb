require 'active_record'
require 'devise'

load 'config/initializers/devise.rb'

Dir["app/models/**/*"].each { |f| load f }

ActiveRecord::Base.establish_connection(
  YAML::load_file("config/database.yml")[ENV["RAILS_ENV"] || "development"]
)

require 'pp' if Orator.debug
