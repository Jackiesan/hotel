require_relative 'spec_helper'


describe "Room class" do

  describe "Room instantiation" do

    before do
      @room = Hotel::Room.new(4)
    end

    it "is an instance of Room" do
      @room.must_be_kind_of Hotel::Room
    end

    it "establishes the base data structures when instantiated" do
      [:room_id, :cost].each do |prop|
        @room.must_respond_to prop
      end

      @room.room_id.must_be_kind_of Integer
      @room.cost.must_be_kind_of Integer
      
    end

  end

end
