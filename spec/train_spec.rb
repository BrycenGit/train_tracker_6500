require('spec_helper')

describe '#Train' do
  
  describe('.all') do
    it("returns an empty array when there are no trains") do
      expect(Train.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves a train") do
      train = Train.new({:color => "Blue", :id => nil})
      train.save()
      train2 = Train.new({:color => "Red", :id => nil})
      train2.save()
      expect(Train.all).to(eq([train, train2]))
    end
  end
  
  describe('.clear') do
    it('clears all trains.')do
      train = Train.new({:color => "Blue", :id => nil})
      train.save()
      train2 = Train.new({:color => "Red", :id => nil})
      train2.save()
      Train.clear
      expect(Train.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same train if it has the same attributes as another train") do
      train = Train.new({:color => "Blue", :id => nil})
      train2 = Train.new({:color => "Blue", :id => nil})
      expect(train).to(eq(train2))
    end
  end

  describe('#update') do
    it("updates a train at attribute") do
      train = Train.new({:color => "Blue", :id => nil})
      train.save()
      train.update({:color => "Red"})
      expect(train.color).to(eq("Red"))
    end
  end

  describe('#delete') do
    it('deletes a train') do
      train = Train.new({:color => "Blue", :id => nil})
      train.save()
      train2 = Train.new({:color => "Blue", :id => nil})
      train2.save()
      train.delete
      expect(Train.all).to(eq([train2]))
    end
  end

  describe('#cities') do
    it("see all cities a train stops at") do
      train = Train.new({:color => "Blue", :id => nil})
      train2 = Train.new({:color => "Blue", :id => nil})
      train.save()
      train2.save()
      train.update({:city_name => "austin", :stop_time => Time.now})
      train.update({:city_name => "austin", :stop_time => Time.now})
      train.update({:city_name => "portland", :stop_time => Time.now})

      expect(train.cities).to(eq('austin'))
    end
  end
end