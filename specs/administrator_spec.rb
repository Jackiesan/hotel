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
      @room_list.length.must_equal 20

      all_costs = @room_list.all? { |room| room.cost_per_night == 200.00 }
      all_costs.must_equal true
    end

    it "stores room id as an integer within range 1 and 20" do
      all_room_ids =  @room_list.all? { |room| (room.room_id.class == Integer) && (room.room_id > 0 || room.room_id < 20) }
      all_room_ids.must_equal true
    end

    it "stores cost per night as a float that is greater or equal to zero" do
      all_costs_per_night =  @room_list.all? { |room| (room.cost_per_night.class == Float) && (room.cost_per_night >= 0) }
      all_costs_per_night.must_equal true
    end



  end

  # describe "reserve_a_room method" do
  #   before do
  #     administrator = Hotel::Administrator.new
  #     @first_reservation = administrator.reserve_a_room(1)
  #   end
  #
  #   it ""
  #
  #
  # end

end
