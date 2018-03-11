require_relative 'spec_helper'
require 'pry'


describe "Room class" do

  describe "Room instantiation" do

    before do
      @room = Hotel::Room.new(4)
    end

    it "is an instance of Room" do
      @room.must_be_kind_of Hotel::Room
    end

    it "establishes the base data structures when instantiated" do
      [:room_id, :reservations, :blocks].each do |prop|
        @room.must_respond_to prop
      end

      @room.room_id.must_be_kind_of Integer
      @room.reservations.must_be_kind_of Array
      @room.blocks.must_be_kind_of Array

    end

  end

  describe "add_reservation(reservation) method" do
    before do
      @room = Hotel::Room.new(4)

      first_reservation_info = {
        reservation_id: 1,
        date: Date.new(2017,2,3),
        number_of_nights: 3,
        room: @room,
        block_of_dates: [Date.new(2017,2,3), Date.new(2017,2,4), Date.new(2017,2,5)]
      }

      @first_reservation = Hotel::Reservation.new(first_reservation_info)

      @room.add_reservation(@first_reservation)
    end

    it "adds a new reservation object to the array of the room's reservations" do

      second_reservation_info = {
        reservation_id: 2,
        date: Date.new(2017,2,8),
        number_of_nights: 2,
        room: @room,
        block_of_dates: [Date.new(2017,2,8), Date.new(2017,2,9)]
      }

      second_reservation = Hotel::Reservation.new(second_reservation_info)

      @room.add_reservation(second_reservation)

      @room.reservations.must_include @first_reservation
      @room.reservations.must_include second_reservation

      all_reservations = @room.reservations.all? { |reservation| reservation.class == Hotel::Reservation }

      all_reservations.must_equal true
    end

    it "raises an argument error if an object other than a Reservation is added" do

      proc{ @room.add_reservation(1) }.must_raise ArgumentError

      proc{ @room.add_reservation("HELLO") }.must_raise ArgumentError

      proc{ @room.add_reservation(Hotel::Room.new(2)) }.must_raise ArgumentError

    end
  end

  describe "add_block method" do

    before do
      administrator = Hotel::Administrator.new
      @block = administrator.create_block(Date.new(2017,3,10), 3, 4)
      @rooms_of_block = @block.rooms

    end

    it "adds instance of block to block collection of each room" do
      @rooms_of_block.each do |room|
        room.add_block(@block)
      end
      all_rooms = @rooms_of_block.all? { |room| room.blocks.include? @block }
      all_rooms.must_equal true
    end

    it "raises an error if argument is not an instance of a Block" do
      proc {
      @rooms_of_block.each do |room|
        room.add_block(3)
      end }.must_raise ArgumentError

      proc {
      @rooms_of_block.each do |room|
        room.add_block("new_block")
      end }.must_raise ArgumentError

    end
  end

  describe "unavailable_nights method" do

    before do
      @room = Hotel::Room.new(4)

      first_reservation_info = {
        reservation_id: 1,
        date: Date.new(2017,2,3),
        number_of_nights: 3,
        room: @room,
        block_of_dates: [Date.new(2017,2,3), Date.new(2017,2,4), Date.new(2017,2,5)]
      }

      first_reservation = Hotel::Reservation.new(first_reservation_info)

      @room.add_reservation(first_reservation)

    end

    it "returns an array of dates in which the room is booked" do

      @room.unavailable_nights.must_be_kind_of Array

      all_unavailable_nights = @room.unavailable_nights.all? { |unavailable_night| unavailable_night.class == Date }
      all_unavailable_nights.must_equal true

      @room.unavailable_nights.length.must_equal 3

    end

    it "returns an empty array if there are no reservations" do
      room = Hotel::Room.new(8)
      room.unavailable_nights.must_be_empty
      room.unavailable_nights.must_be_kind_of Array

    end

    it "is able to update booked nights array if more reservations are added" do

      second_reservation_info = {
        reservation_id: 2,
        date: Date.new(2017,2,6),
        number_of_nights: 2,
        room: @room,
        block_of_dates: [Date.new(2017,2,6), Date.new(2017,2,7)]
      }

      second_reservation = Hotel::Reservation.new(second_reservation_info)

      @room.add_reservation(second_reservation)
      @room.unavailable_nights.length.must_equal 5
      @room.unavailable_nights.must_include Date.new(2017,2,6) && Date.new(2017,2,7)
    end

    it "includes dates from a block (sets as unavailable_nights to the public)" do
      administrator = Hotel::Administrator.new

      block = administrator.create_block(Date.new(2017,3,10), 3, 4)

      rooms_for_block = block.rooms

      rooms_for_block.all? { |room| room.unavailable_nights.include? Date.new(2017,3,10) && Date.new(2017,3,11) && Date.new(2017,3,11) }

    end

  end

end
