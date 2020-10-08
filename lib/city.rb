class City
attr_accessor :name
attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_cities = DB.exec("SELECT * FROM cities;")
    cities = []
    returned_cities.each() do |city|
      name = city.fetch("name")
      id = city.fetch("id").to_i
      cities.push(City.new({:name => name, :id => id}))
    end
    cities
  end

  def self.clear
    DB.exec("DELETE FROM cities *;")
  end

  def self.find(id)
    city = DB.exec("SELECT * FROM cities WHERE id = #{id};").first
    name = city.fetch("name")
    id = city.fetch("id").to_i
    City.new({:name => name, :id => id})
  end

  def save
    result = DB.exec("INSERT INTO cities (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(param)
    self.name() == param.name()
  end

  def delete
    DB.exec("DELETE FROM trains_cities WHERE city_id = #{@id};")
    DB.exec("DELETE FROM cities WHERE id = #{@id};")
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE cities SET name = '#{@name}' WHERE id = #{@id};")
    elsif (attributes.has_key?(:color)) && (attributes.fetch(:color) != nil)
      train_color = attributes.fetch(:color)
      stop_time = attributes.fetch(:stop_time)
      train = DB.exec("SELECT * FROM trains WHERE lower(color)='#{train_color.downcase}';").first
      if train != nil
        DB.exec("INSERT INTO trains_cities (train_id, city_id, stop_time) VALUES (#{train['id'].to_i}, #{@id}, '#{stop_time}');")
      else
        new_train = Train.new({:color => train_color, :id => nil})
        new_train.save
        DB.exec("INSERT INTO trains_cities (train_id, city_id, stop_time) VALUES (#{new_train.id}, #{@id}, '#{stop_time}');")
      end
    end

  end

  def trains
    trains = {}
    results = DB.exec("SELECT train_id, stop_time FROM trains_cities WHERE city_id = #{@id};")
    results.each() do |result|
      train_id = result.fetch("train_id").to_i()
      stop_time = result.fetch("stop_time")
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
      color = train.first().fetch("color")
      trains[stop_time] = Train.new({:color => color, :id => train_id})
    end
    trains.values
  end
end