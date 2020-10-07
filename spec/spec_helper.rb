require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'artist'
require 'pry'

DB = PG.connect({:dbname => 'train_system_test', :password => ENV['PG_PASS'] })