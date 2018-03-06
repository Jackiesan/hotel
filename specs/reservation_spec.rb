require_relative 'spec_helper'

describe "Reservation class" do

  describe "Reservation instantiation" do

    before do
      @reservation = Hotel::Reservation.new(1, Date.new(2017,2,3), 3, 4)
    end

    it "is an instance of Reservation" do
      @reservation.must_be_kind_of Hotel::Reservation
    end

    it "establishes the base data structures when instantiated" do
      [:reservation_id, :date, :number_of_nights, :room_id].each do |prop|
        @reservation.must_respond_to prop
      end

      @reservation.reservation_id.must_be_kind_of Integer
      @reservation.date.must_be_kind_of Date
      @reservation.number_of_nights.must_be_kind_of Integer
      @reservation.room_id.must_be_kind_of Integer

    end

  end

  describe "total_cost method" do

    before do
        @reservation = Hotel::Reservation.new(1, Date.new(2017,2,3), 3, 4)
    end

    it "returns the total cost of the reservation" do
      @reservation.total_cost.must_equal 600.00
    end

    it "returns the value as a float" do
      @reservation.total_cost.must_be_kind_of Float
    end
  end

end
