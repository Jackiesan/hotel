require_relative 'spec_helper'

describe "Reservation class" do

  describe "Reservation instantiation" do

    before do
      @administrator = Hotel::Administrator.new

      @reservation_info = {
        reservation_id: 1,
        start_date: Date.new(2017,2,3),
        number_of_nights: 3,
        room: @administrator.find_room(1),
        block_of_dates: [Date.new(2017,2,3), Date.new(2017,2,4), Date.new(2017,2,5)],
        room_rate: 200.00

      }

      @reservation = Hotel::Reservation.new(@reservation_info)
    end

    it "is an instance of Reservation" do
      @reservation.must_be_kind_of Hotel::Reservation
    end

    it "establishes the base data structures when instantiated" do
      [:reservation_id, :start_date, :number_of_nights, :room, :block_of_dates, :room_rate, :check_out_date].each do |prop|
        @reservation.must_respond_to prop
      end

      @reservation.reservation_id.must_be_kind_of Integer
      @reservation.start_date.must_be_kind_of Date
      @reservation.number_of_nights.must_be_kind_of Integer
      @reservation.room.must_be_kind_of Hotel::Room
      @reservation.block_of_dates.must_be_kind_of Array
      @reservation.room_rate.must_be_kind_of Float
      @reservation.check_out_date.must_be_kind_of Date
    end

  end

  describe "total_cost method" do

    before do
      administrator = Hotel::Administrator.new

      reservation_info = {
        reservation_id: 1,
        date: Date.new(2017,2,3),
        number_of_nights: 3,
        room: administrator.find_room(1),
        block_of_dates: [Date.new(2017,2,3), Date.new(2017,2,4), Date.new(2017,2,5)],
        room_rate: 200.00

      }

      @reservation = Hotel::Reservation.new(reservation_info)
    end

    it "returns the total cost of the reservation" do
      @reservation.total_cost.must_equal 600.00
    end

    it "returns the value as a float" do
      @reservation.total_cost.must_be_kind_of Float
    end
  end

end
