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
        start_date: Date.new(2017,3,10),
        number_of_nights: 2,
        rooms: [first_room, second_room, third_room, fourth_room, fifth_room]
      }

      @block = Hotel::Block.new(block_info)
    end

    it "is an instance of a Block" do
      @block.must_be_kind_of Hotel::Block
    end

    it "establishes the base data structures when instantiated" do
      [:block_id, :start_date, :number_of_nights, :rooms, :reservations].each do |prop|
        @block.must_respond_to prop
      end

      @block.block_id.must_be_kind_of Integer
      @block.start_date.must_be_kind_of Date
      @block.number_of_nights.must_be_kind_of Integer
      @block.rooms.must_be_kind_of Array
      @block.reservations.must_be_kind_of Array
    end

    it "establishes @rooms as array of Room objects" do
      all_rooms =  @block.rooms.all? { |room| room.class == Hotel::Room}
      all_rooms.must_equal true

    end

  end

  describe "dates of block method" do

    before do
      @administrator = Hotel::Administrator.new
      first_room = @administrator.find_room(1)
      second_room = @administrator.find_room(2)

      block_info = {
        block_id: 1,
        start_date: Date.new(2017,3,10),
        number_of_nights: 2,
        rooms: [first_room, second_room]
      }

      @block = Hotel::Block.new(block_info)
    end

    it "returns array of date objects" do
      @block.dates_of_block.must_be_kind_of Array
      @block.dates_of_block.length.must_equal 2
      @block.dates_of_block.must_include Date.new(2017,3,10) && Date.new(2017,3,11)

      all_dates = @block.dates_of_block.all? { |date| date.class == Date }
      all_dates.must_equal true

    end

  end

  describe "add_reservation(reservation) method" do
    before do
      administrator = Hotel::Administrator.new
      first_room = administrator.find_room(1)
      second_room = administrator.find_room(2)
      third_room = administrator.find_room(3)

      block_info = {
        block_id: 1,
        start_date: Date.new(2017,3,10),
        number_of_nights: 3,
        rooms: [first_room, second_room, third_room]
      }

      @block = Hotel::Block.new(block_info)

      reservation_info = {
        reservation_id: 1,
        start_date: Date.new(2017, 3, 10),
        number_of_nights: 3,
        room: @block.rooms.first,
        block_of_dates: [Date.new(2017,3,10), Date.new(2017,3,11), Date.new(2017,3,12)],
        room_rate: 175.00
      }

      @reservation = Hotel::Reservation.new(reservation_info)
    end

    it "adds reservation to reservation collection within Block" do
      @block.add_reservation(@reservation)

      @block.reservations.must_include @reservation
      @block.reservations.length.must_equal 1
    end

    it "raises an argument error if an object that is not an instance of Reservation is added" do
      proc { @block.add_reservation("new_reservation") }.must_raise ArgumentError

      proc { @block.add_reservation(33) }.must_raise ArgumentError

      proc { @block.add_reservation(Hotel::Room.new(4)) }.must_raise ArgumentError

    end

  end
end
