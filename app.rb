#!/usr/bin/env ruby
require('sinatra')
require('sinatra/reloader')
require('./lib/city')
require('./lib/train')

require('pry')
require("pg")
require('dotenv/load')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "train_system", :password => ENV['PG_PASS']})