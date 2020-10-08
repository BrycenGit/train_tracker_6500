require 'rspec'
require 'pg'
require 'city'
require 'train'
require 'pry'
require('dotenv/load')

DB = PG.connect({:dbname => 'train_system_test', :password => ENV['PG_PASS'] })

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM trains *;")
    DB.exec("DELETE FROM cities *;")
    DB.exec("DELETE FROM trains_cities *;")
  end
end