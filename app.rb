#!/usr/bin/env ruby
require('sinatra')
require('sinatra/reloader')
require('./lib/city')
require('./lib/train')
require('pry')
require("pg")
require('dotenv/load')
require('sinatra/base')
also_reload('lib/**/*.rb')


DB = PG.connect({:dbname => "train_system", :password => ENV['PG_PASS']})


get('/') do
  redirect to('/trains')
end  

get('/trains') do
  @trains = Train.all
  erb(:trains)
end  

get('/trains/new') do
  erb(:train_new)
end  

post('/trains') do
  color = params[:color]
  train = Train.new({:color => color, :id => nil})
  train.save()
  redirect to('/trains')
end  

get('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  @train.cities
  erb(:train)
end

post('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  city_name = params[:name]
  time = params[:stop_time]
  ##############################
  @train.update({:city_name => city_name, :stop_time => time})
  @cities = @train.cities
  erb(:train)
end


patch('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  color = params[:color]
  @train.update({:color => color})
  redirect to("/trains/#{params[:id].to_i()}")
end  

delete('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  @train.delete
  redirect to('/trains')
end  

get('/cities') do
  @cities = City.all
  erb(:cities)
end

post('/cities') do
  name = params[:name]
  city = City.new({:name => name, :id => nil})
  city.save()
  redirect to('/cities')
end

get('/cities/:id') do
  @city = City.find(params[:id].to_i)
  erb(:city)
end

post('/cities/:id') do
  @city = City.find(params[:id].to_i)
  time = params[:train_time]
  color = params[:train_color]
  @city.update({:color => color, :stop_time => time})
  @trains = @city.trains
  erb(:city)
end

delete('/cities/:id') do
  @city = City.find(params[:id].to_i)
  @city.delete
  redirect to('/cities')
end

get('/tickets') do
  @info = Train.info
  erb(:tickets)
end

get('/info') do
  @info = Train.info
  erb(:info)
end