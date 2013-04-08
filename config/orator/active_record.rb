require 'active_record'

Dir["app/models/**/*"].each { |f| load f }

ActiveRecord::Base.establish_connection(
  YAML::load_file("config/database.yml")[ENV["RAILS_ENV"] || "development"]
)
