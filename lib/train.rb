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
      train.push(Train.new({:color => color, :id => id}))
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
    result = DB.exec("INSERT INTO train (color) VALUE ('#{@color}') RETURNING id;")
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

  def update(attributes)
    if (attributes.has_key?(:color)) && (attributes.fetch(:color) != nil)
      @color = attributes.fetch(:name)
      DB.exec("UPDATE trains SET color = '#{@color}' WHERE id = #{@id;};")
    elsif (attributes.fetch())  
  end

  def cities
  end

end