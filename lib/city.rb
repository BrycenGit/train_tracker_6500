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

  def self.find
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
    elsif (attributes.has_key?(:train_name)) && (attributes.fetch(:train_name) != nil)
      train_name = attributes.fetch(:train_name)
      train = DB.exec("SELECT * FROM trains WHERE lower(name)='#{train_name.downcase}';").first
      if train != nil
        DB.exec("INSERT INTO trains_cities (train_id, city_id) VALUES (#{train['id'].to_i}, #{@id});")
      end
    end

  end

  def trains
    trains = []
    results = DB.exec("SELECT train_id FROM trains_cities WHERE city_id = #{@id};")
    results.each() do |result|
      train_id = result.fetch("train_id").to_i()
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
      name = train.first().fetch("name")
      trains.push(train.new({:name => name, :id => train_id}))
    end
    trains
  end

end