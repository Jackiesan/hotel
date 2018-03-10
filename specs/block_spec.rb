require_relative 'spec_helper'

describe "Block class" do

  describe "Block instantiation" do

    before do
      administrator = Hotel::Administrator.new
      first_room = administrator.find_room(1)
      second_room = administrator.find_room(2)
      third_room = administrator.find_room(3)
      fourth_room = administrator.find_room(4)
      fifth_room = administrator.find_room(5)

      block_info = {
        block_id: 1,
        date: Date.new(2017,3,10),
        number_of_nights: 2,
        rooms: [first_room, second_room, third_room, fourth_room, fifth_room]
      }

      @block = Hotel::Block.new(block_info)
    end

    it "is an instance of a Block" do
      @block.must_be_kind_of Hotel::Block
    end

    it "establishes the base data structures when instantiated" do
      [:block_id, :date, :number_of_nights, :rooms].each do |prop|
        @block.must_respond_to prop
      end

      @block.block_id.must_be_kind_of Integer
      @block.date.must_be_kind_of Date
      @block.number_of_nights.must_be_kind_of Integer
      @block.rooms.must_be_kind_of Array
    end

    it "establishes @rooms as array of Room objects" do
      all_rooms =  @block.rooms.all? { |room| room.class == Hotel::Room}
      all_rooms.must_equal true

    end

  end
end
