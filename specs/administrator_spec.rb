require_relative 'spec_helper'

describe "Administrator class" do

  describe "Administrator instantiation" do

    before do
      @administrator = Hotel::Administrator.new
    end

    it "is an instance of Administrator" do
      @administrator.must_be_kind_of Hotel::Administrator
    end

    it "establishes the base data structures when instantiated" do
      [:rooms, :reservations].each do |prop|
        @administrator.must_respond_to prop
      end

      @administrator.rooms.must_be_kind_of Array
      @administrator.reservations.must_be_kind_of Array

    end

  end

  describe "Room_list method" do
    before do
      administrator = Hotel::Administrator.new
      @room_list = administrator.room_list
    end

    it "loads a list of room instances into room_list array" do
      @room_list.must_be_kind_of Array
      all_rooms = @room_list.all? { |room| room.class == Hotel::Room }
      all_rooms.must_equal true
    end

    it "accurately loads the information of the room" do
      @room_list.first.room_id.must_equal 1
      @room_list.last.room_id.must_equal 20

      all_costs = @room_list.all? { |room| room.cost_per_night == 200.00 }
      all_costs.must_equal true
    end
  end

end
