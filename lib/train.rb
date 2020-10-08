class Train
  attr_reader :id, :city_id
  attr_accessor :color 

  def initialize(attributes)
    @color = attributes.fetch(:color)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_trains = DB.exec("SELECT * FROM trains")
    trains = []
    returned_trains.each() do |train|
      color = train.fetch("color")
      id = train.fetch('id').to_i
      trains.push(Train.new({:color => color, :id => id}))
    end
    trains  
  end

  def self.clear #Just a DB.exec - don't overthink this
    DB.exec("DELETE FROM trains *;")
  end

  def self.find(id)
    train = DB.exec("SELECT * FROM trains WHERE id =#{id};").first
    color = train.fetch("color")
    id = train.fetch("id").to_i
    Train.new({:color => color, :id => id})
  end

  def save #saves name and then fetches PRIMARY KEY from db
    result = DB.exec("INSERT INTO trains (color) VALUES ('#{@color}') RETURNING id;")
    @id =result.first().fetch("id").to_i
  end

  def ==(train_to_compare)
    if train_to_compare != nil
      (self.color() == train_to_compare.color()) && (self.id() == train_to_compare.id())
    else
      false  
    end  
  end  

  def delete
    DB.exec("DELETE FROM trains WHERE id = #{@id};")
    DB.exec("DELETE FROM trains_cities WHERE train_id = #{@id};")
  end

  def update(attributes) #interfaces with forms - symbols are tied to form fields
    if (attributes.has_key?(:color)) && (attributes.fetch(:color) != nil) # keys are tethered to params from erb
      @color = attributes.fetch(:color)
      DB.exec("UPDATE trains SET color = '#{@color}' WHERE id = #{@id;};")  
    elsif (attributes.has_key?(:city_name)) && (attributes.fetch(:city_name) != nil) # has_key? is checking to see which TABLE we are looking at -- THIS IS NOT REALLY UPDATING
      city_name = attributes.fetch(:city_name)
      stop_time = attributes.fetch(:stop_time)
      city = DB.exec("SELECT * FROM cities WHERE lower(name) ='#{city_name.downcase}';").first
      if city != nil
        DB.exec("INSERT INTO trains_cities (city_id, train_id, stop_time) VALUES (#{city['id'].to_i}, #{@id}, '#{stop_time}');") # if city is there, do this!

      else
        new_city = City.new({:name => city_name, :id => nil}) # if city IS NOT there make new instance
        new_city.save
        DB.exec("INSERT INTO trains_cities (city_id, train_id, stop_time) VALUES (#{new_city.id}, #{@id}, '#{stop_time}');")

      end
    end
  end

  def cities
    cities = []
    results = DB.exec("SELECT city_id, stop_time FROM trains_cities WHERE train_id = #{@id};")
    results.each() do |result|
      city_id = result.fetch("city_id").to_i()
      stop_time = result.fetch("stop_time")
      city = DB.exec("SELECT * FROM cities WHERE id = #{city_id};")
      name = city.first().fetch("name")
      array = [City.new({:name => name, :id => city_id}), stop_time]
      if cities.include?(array)
      else
        cities << array
      end
    end
    cities
  end

  def self.info # 0=city name 1=train, 2=time
    info = [] # houses multiple arrays -- each with train stop info
    results = DB.exec("SELECT train_id, city_id, stop_time FROM trains_cities;")
    results.each() do |result|
      train_id = result.fetch("train_id").to_i()
      city_id = result.fetch("city_id").to_i()
      stop_time = result.fetch("stop_time")
      city = DB.exec("SELECT * FROM cities WHERE id = #{city_id};")
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
      city_name = city.first().fetch("name")
      train_name = train.first().fetch("color")
      array = [city_name, train_name, stop_time]
      if info.include?(array)
      else
        info << array
      end
    end
    info
  end
end

