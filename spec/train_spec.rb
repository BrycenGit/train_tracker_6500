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


end