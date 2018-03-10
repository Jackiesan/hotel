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
      [:rooms, :reservations, :blocks].each do |prop|
        @administrator.must_respond_to prop
      end

      @administrator.rooms.must_be_kind_of Array
      @administrator.reservations.must_be_kind_of Array
      @administrator.blocks.must_be_kind_of Array

    end

    it "establishes rooms as array of objects, reservations initializes as empty array" do
      all_rooms =  @administrator.rooms.all? { |room| room.class == Hotel::Room}
      all_rooms.must_equal true

      @administrator.reservations.must_be_empty

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

      all_room_reservations = @room_list.all? { |room| room.reservations.class == Array }
      all_room_reservations.must_equal true
    end

    it "stores room id as an integer within range 1 and 20" do
      all_room_ids =  @room_list.all? { |room| (room.room_id.class == Integer) && (room.room_id > 0 || room.room_id < 20) }
      all_room_ids.must_equal true
      @room_list.length.must_equal 20
    end

  end

  describe "find_room(room_id) method" do

    before do
      @administrator = Hotel::Administrator.new
    end

    it "raises error if room id entered is not within 1 - 20" do
      proc { @administrator.find_room(21) }.must_raise ArgumentError

      proc { @administrator.find_room(0) }.must_raise ArgumentError

      proc { @administrator.find_room(-56) }.must_raise ArgumentError

      proc { @administrator.find_room("hello") }.must_raise ArgumentError
    end

    it "returns the room object corresponding to the room_id number entered" do
      room_id = 0
      rooms_searched = []
      20.times do
        rooms_searched << @administrator.find_room(room_id += 1)
      end

      rooms_found = rooms_searched.all? { |room| room.class == Hotel::Room}
      rooms_found.must_equal true
    end

  end

  describe "reservations_on_date method" do
    it "returns list of Reservations on a specific date" do

      administrator = Hotel::Administrator.new
      first_reservation = administrator.reserve_a_room(Date.new(2017,2,3), 3, 9)
      second_reservation = administrator.reserve_a_room(Date.new(2017,2,3), 5, 10)
      administrator.reserve_a_room(Date.new(2017,2,6), 5, 12)

      administrator.reservations_on_date(Date.new(2017,2,3)).length.must_equal 2

      administrator.reservations_on_date(Date.new(2017,2,3)).must_include first_reservation && second_reservation

    end

    it "returns error if the argument passed is not an object of Date" do
      administrator = Hotel::Administrator.new
      proc { administrator.reservations_on_date(343) }.must_raise ArgumentError

      proc { administrator.reservations_on_date(Hotel::Room.new(1)) }.must_raise ArgumentError

    end
  end

  describe "show_rooms_available method" do

    before do
      @administrator = Hotel::Administrator.new

      @administrator.reserve_a_room(Date.new(2017,2,3), 3, 9)
      @administrator.reserve_a_room(Date.new(2017,2,3), 5, 10)
      @administrator.reserve_a_room(Date.new(2017,2,6), 5, 9)

    end

    it "returns array of room objects that are available during date range" do

      rooms_available = @administrator.show_rooms_available(Date.new(2017,2,3), 3)

      rooms_available.must_be_kind_of Array

      list_of_rooms = rooms_available.all? { |room| room.class == Hotel::Room }
      list_of_rooms.must_equal true

      rooms_available.length.must_equal 18

    end

    it "raises argument error is 1st argument is not Date object or if number_of_nights is not an integer" do
      proc { @administrator.show_rooms_available("tuesday", 3) }.must_raise ArgumentError

      proc { @administrator.show_rooms_available(Date.new(2017,2,3), 0) }.must_raise ArgumentError
    end

    it "returns 20 rooms available if there are no existing reservations" do
      new_administrator = Hotel::Administrator.new

      new_administrator.show_rooms_available(Date.new(2017,3,2), 1).length.must_equal 20
    end
  end

  describe "reserve_a_room method" do
    before do
      @administrator = Hotel::Administrator.new
      @room = @administrator.room_list[8]
      @first_reservation = @administrator.reserve_a_room(Date.new(2017,2,3), 3, 9)
    end

    it "returns/creates a new instance of Reservation" do
      @first_reservation.must_be_kind_of Hotel::Reservation
    end

    it "accurately accesses information of the new reservation" do
      @first_reservation.reservation_id.must_equal 1
      @first_reservation.date.must_equal Date.new(2017,2,3)
      @first_reservation.number_of_nights.must_equal 3
      @first_reservation.room.room_id.must_equal 9

      @first_reservation.reservation_id.must_be_kind_of Integer
      @first_reservation.date.must_be_kind_of Date
      @first_reservation.number_of_nights.must_be_kind_of Integer
      @first_reservation.room.must_be_kind_of Hotel::Room
    end

    it "adds the new Reservation to the collection of reservations in Administrator" do
      second_reservation = @administrator.reserve_a_room(Date.new(2017,1,3), 2, 1)

      third_reservation =
      @administrator.reserve_a_room(Date.new(2017,1,22), 3, 8)

      @administrator.reservations.length.must_equal 3

      @administrator.reservations.must_include @first_reservation
      @administrator.reservations.must_include second_reservation
      @administrator.reservations.must_include third_reservation
    end

    it "raises an error if new reservation overlaps with an existing reservation" do
      proc { @administrator.reserve_a_room(Date.new(2017,2,3), 2, 9) }.must_raise ArgumentError

      proc { @administrator.reserve_a_room(Date.new(2017,2,5), 2, 9) }.must_raise ArgumentError


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
