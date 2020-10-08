class Ticket
  attr_reader :type
  attr_accessor :price, :id
  def initialize(attributes)

    @type = attributes.fetch(:type)
    @price = attributes.fetch(:price)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_tickets = DB.exec("SELECT * FROM tickets")
    tickets = []
    returned_tickets.each() do |ticket|
      ticket_type = ticket.fetch("ticket_type")
      ticket_price = ticket.fetch("ticket_price")

      id = ticket.fetch('id').to_i
      tickets.push(Ticket.new({:type => ticket_type, :price => ticket_price, :id => id}))
    end
    tickets  
  end
  

  def self.find(id)
    ticket = DB.exec("SELECT * FROM tickets WHERE id = #{id};").first
    ticket_type = ticket.fetch("ticket_type")
    ticket_price = ticket.fetch("ticket_price")
    id = ticket.fetch('id').to_i
    Ticket.new({:type => ticket_type, :price => ticket_price, :id => id})
  end

  def self.clear #Just a DB.exec - don't overthink this
    DB.exec("DELETE FROM tickets *;")
  end

  def ==(ticket_to_compare)
    if ticket_to_compare != nil
      (self.type() == to_compare.ticket_type()) && (self.id() == ticket_to_compare.id())
    else
      false  
    end  
  end 
  

  def delete()
    DB.exec("DELETE FROM tickets WHERE id = #{@id};")
  end

  def save(attributes) #saves name and then fetches PRIMARY KEY from db
    train = attributes.fetch(:train)
    # city = attributes.fetch(:city)
    result = DB.exec("INSERT INTO tickets (ticket_type, ticket_price, train) VALUES ('#{@type}', #{@price}, '#{train}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ticket_price
    if @type == "Day Pass"
      @price = 5
    elsif @type == "Weekend Pass"
      @price = 10
    elsif  @type == "Week Pass"
      @price = 25
    elsif @type == "Month Pass"
      @price = 50
    elsif @type == "Annual Pass"  
      @price = 300
    elsif @type == "One-Way" 
      @price = 1
    elsif @type == "Round Trip"   
      @price = 2
    else
      false
    end    
  end  
    
    
  
  def self.info
    info = []

    results = DB.exec("SELECT * FROM tickets;")
    results.each() do |result|
      ticket_type = result.fetch("ticket_type") #0
      ticket_price = result.fetch("ticket_price") #1

      id = result.fetch('id').to_i #3
      train = result.fetch('train') #4

      hash = {:ticket_type => ticket_type, :ticket_price => ticket_price, :id => id, :train => train}
      if info.include?(hash)
      else
        info << hash
      end
    end
    info
  end
end