require('spec_helper')

describe '#city' do
  
  describe('.all') do
    it("returns an empty array when there are no cities") do
      expect(City.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves a city") do
      city = City.new({:name => "portland", :id => nil})
      city.save()
      city2 = City.new({:name => "eugene", :id => nil})
      city2.save()
      expect(City.all).to(eq([city, city2]))
    end
  end
  
  describe('.clear') do
    it('clears all cities.')do
      city = City.new({:name => "portland", :id => nil})
      city.save()
      city2 = City.new({:name => "eugene", :id => nil})
      city2.save()
      City.clear
      expect(City.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same city if it has the same attributes as another city") do
      city = City.new({:name => "portland", :id => nil})
      city2 = City.new({:name => "portland", :id => nil})
      expect(city).to(eq(city2))
    end
  end

  describe('#update') do
    it("updates a city at attribute") do
      city = City.new({:name => "portland", :id => nil})
      city.save()
      city.update({:name => "austin"})
      expect(city.name).to(eq("austin"))
    end
  end

  describe('#delete') do
    it('deletes a city') do
      city = City.new({:name => "portland", :id => nil})
      city.save()
      city2 = City.new({:name => "portland", :id => nil})
      city2.save()
      city.delete
      expect(City.all).to(eq([city2]))
    end
  end

  describe('#trains') do
    it("see all cities a train stops at") do
      city = City.new({:name => "portland", :id => nil})
      city.save()
      city.update({:color => "red", :stop_time => Time.now})
      expect(city.trains[0].color).to(eq('red'))
    end
  end
end
