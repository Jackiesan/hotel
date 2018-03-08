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
      [:room_id, :reservations].each do |prop|
        @room.must_respond_to prop
      end

      @room.room_id.must_be_kind_of Integer
      @room.reservations.must_be_kind_of Array

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

      @room.reservations.length.must_equal 1

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

  describe "booked_nights method" do

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

      @room.booked_nights.must_be_kind_of Array

      all_booked_nights = @room.booked_nights.all? { |booked_date| booked_date.class == Date }
      all_booked_nights.must_equal true

      @room.booked_nights.length.must_equal 3

    end

    it "returns an empty array if there are no reservations" do
      room = Hotel::Room.new(8)
      room.booked_nights.length.must_equal 0
      room.booked_nights.must_be_kind_of Array

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
      @room.booked_nights.length.must_equal 5
      @room.booked_nights.must_include Date.new(2017,2,6) && Date.new(2017,2,7)
    end
  end

end
