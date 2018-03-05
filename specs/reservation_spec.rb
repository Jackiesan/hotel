require_relative 'spec_helper'

describe "Reservation class" do

  describe "Reservation instantiation" do

    before do
      administrator = Hotel::Administrator.new
      @reservation = administrator.reserve_a_room(Date.new(2017,2,3), 3, 4)
    end

    it "is an instance of Reservation" do
      @reservation.must_be_kind_of Hotel::Reservation
    end

    it "establishes the base data structures when instantiated" do
      [:date, :number_of_nights, :room_id].each do |prop|
        @reservation.must_respond_to prop
      end

      @reservation.date.must_be_kind_of Date
      @reservation.number_of_nights.must_be_kind_of Integer
      @reservation.room_id.must_be_kind_of Integer

    end

  end

end
