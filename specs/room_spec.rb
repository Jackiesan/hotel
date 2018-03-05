require_relative 'spec_helper'


describe "Room class" do

  describe "Room instantiation" do

    it "is an instance of Room" do
      room = Hotel::Room.new(4)
      room.must_be_kind_of Hotel::Room
    end

    # it "establishes the base data structures when instantiated" do
    #   [:date, :number_of_nights, :room_id].each do |prop|
    #     @reservation.must_respond_to prop
    #   end
    #
    #   @reservation.date.must_be_kind_of Date
    #   @reservation.number_of_nights.must_be_kind_of Integer
    #   @reservation.room_id.must_be_kind_of Integer
    #
    # end

  end

end
