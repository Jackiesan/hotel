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

  describe "room_list method" do
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

  describe "reserve_a_room method" do
    before do
      @administrator = Hotel::Administrator.new
      @initial_reservations_length = @administrator.reservations.length
      @first_reservation = @administrator.reserve_a_room(Date.new(2017,2,3), 3, 9)
    end

    it "returns/creates a new instance of Reservation" do
      @first_reservation.must_be_kind_of Hotel::Reservation
    end

    it "accurately accesses information of the new reservation" do
      @first_reservation.reservation_id.must_equal 1
      @first_reservation.date.must_equal Date.new(2017,2,3)
      @first_reservation.number_of_nights.must_equal 3
      @first_reservation.room_id.must_equal 9

      @first_reservation.reservation_id.must_be_kind_of Integer
      @first_reservation.date.must_be_kind_of Date
      @first_reservation.number_of_nights.must_be_kind_of Integer
      @first_reservation.room_id.must_be_kind_of Integer
    end

    it "adds the new Reservation to the collection of reservations in Administrator" do
      #2nd reservation
      @administrator.reserve_a_room(Date.new(2017,1,3), 2, 1)

      #3rd reservation
      @administrator.reserve_a_room(Date.new(2017,1,22), 3, 8)

      @administrator.reservations.length.must_equal @initial_reservations_length + 3

      @administrator.reservations[0].reservation_id.must_equal 1
      @administrator.reservations[1].reservation_id.must_equal 2
      @administrator.reservations[2].reservation_id.must_equal 3

    end

    it "raises an error if a date is nil or not a date" do
      proc{@administrator.reserve_a_room(nil, 3, 9)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room("hello", 3, 9)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(3, 3, 9)}.must_raise ArgumentError
    end

    it "raises an error if number_of_nights is nil, zero, negative, float, or non-integer" do
      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 0, 9)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), -9, 9)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), "hello", 9)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), nil, 9)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 6.5, 9)}.must_raise ArgumentError

    end

    it "raises an error is the room_id is not within range 1-20" do
      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, 21)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, 0)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, -99)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, "hello")}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, nil)}.must_raise ArgumentError
    end

  end

end
