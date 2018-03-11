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
      @administrator.blocks.must_be_empty

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

    it "can access the information of the rooms" do
      @room_list.first.room_id.must_equal 1
      @room_list.last.room_id.must_equal 20
      @room_list.length.must_equal 20

      all_room_reservations = @room_list.all? { |room| room.reservations.class == Array }
      all_room_reservations.must_equal true

      all_room_blocks = @room_list.all? { |room| room.blocks.class == Array }
      all_room_blocks.must_equal true
    end

    it "stores room id as an integer within range 1 and 20" do
      all_room_ids =  @room_list.all? { |room| (room.room_id.class == Integer) && (room.room_id > 0 || room.room_id < 20) }
      all_room_ids.must_equal true
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

    before do
      @administrator = Hotel::Administrator.new

      #room with a check out date of 2/6/17
      @first_reservation = @administrator.reserve_a_room(Date.new(2017,2,3), 3, 9)

      @second_reservation = @administrator.reserve_a_room(Date.new(2017,2,3), 5, 10)

      #same room as @first_reservation but checking in 2/6/17
      @third_reservation = @administrator.reserve_a_room(Date.new(2017,2,6), 1, 9)

    end
    it "returns list of Reservations on a specific date" do

      reservation_list = @administrator.reservations_on_date(Date.new(2017,2,6))

      reservation_list.length.must_equal 3

      reservation_list.must_include @first_reservation && @second_reservation && @third_reservation

      reservation_list.all? { |reservation| reservation.class == Hotel::Reservation }

    end

    it "returns error if the argument passed is not an object of Date" do

      proc { @administrator.reservations_on_date(343) }.must_raise ArgumentError

      proc { @administrator.reservations_on_date(Hotel::Room.new(1)) }.must_raise ArgumentError

    end

    it "returns empty array if no reservations exist for that date" do
      list_of_reservations = @administrator.reservations_on_date(Date.new(2017,3,10))

      list_of_reservations.must_be_empty

    end
  end

  describe "show_rooms_available method" do

    before do
      @administrator = Hotel::Administrator.new

      @administrator.reserve_a_room(Date.new(2017,2,3), 3, 1)
      @administrator.reserve_a_room(Date.new(2017,2,3), 5, 2)
      @administrator.reserve_a_room(Date.new(2017,2,6), 5, 1)

    end

    it "returns array of room objects that are available during date range" do

      room_one = @administrator.find_room(1)
      room_two = @administrator.find_room(2)

      rooms_available = @administrator.show_rooms_available(Date.new(2017,2,6), 3)

      rooms_available.must_be_kind_of Array

      list_of_rooms = rooms_available.all? { |room| room.class == Hotel::Room }
      list_of_rooms.must_equal true

      rooms_available.length.must_equal 18


      rooms_available.wont_include room_one || room_two

    end

    it "raises argument error is 1st argument is not Date object or if number_of_nights is not an integer" do
      proc { @administrator.show_rooms_available("tuesday", 3) }.must_raise ArgumentError

      proc { @administrator.show_rooms_available(Date.new(2017,2,3), 0) }.must_raise ArgumentError
    end

    it "returns 20 rooms available if there are no existing reservations" do
      new_administrator = Hotel::Administrator.new

      new_administrator.show_rooms_available(Date.new(2017,3,2), 1).length.must_equal 20
    end

    it "returns an empty array if no rooms are available" do
      new_administrator = Hotel::Administrator.new

      i = 0
      20.times do |reservation|
        new_administrator.reserve_a_room(Date.new(2017,2,3), 2, i += 1)
      end

      new_administrator.show_rooms_available(Date.new(2017,2,4),2).must_be_empty

    end
  end

  describe "reserve_a_room method" do
    before do
      @administrator = Hotel::Administrator.new
      @room = @administrator.find_room(9)
      @first_reservation = @administrator.reserve_a_room(Date.new(2017,2,3), 3, 9)
    end

    it "returns/creates a new instance of Reservation" do
      @first_reservation.must_be_kind_of Hotel::Reservation
    end

    it "accurately accesses information of the new reservation" do
      @first_reservation.reservation_id.must_equal 1
      @first_reservation.start_date.must_equal Date.new(2017,2,3)
      @first_reservation.number_of_nights.must_equal 3
      @first_reservation.room.must_equal @room
      @first_reservation.block_of_dates.must_equal [Date.new(2017,2,3), Date.new(2017,2,4), Date.new(2017,2,5)]
      @first_reservation.room_rate.must_equal 200.00
      @first_reservation.check_out_date.must_equal Date.new(2017,2,6)

      @first_reservation.reservation_id.must_be_kind_of Integer
      @first_reservation.start_date.must_be_kind_of Date
      @first_reservation.number_of_nights.must_be_kind_of Integer
      @first_reservation.room.must_be_kind_of Hotel::Room
      @first_reservation.block_of_dates.must_be_kind_of Array
      @first_reservation.room_rate.must_be_kind_of Float
      @first_reservation.check_out_date.must_be_kind_of Date
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

    it "adds the new reservation to the collection of Reservations of the Room" do
      @room.reservations.must_include @first_reservation
      @room.reservations.length.must_equal 1
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

    it "raises an error if the room_id is not within range 1-20" do
      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, 21)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, 0)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, -99)}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, "hello")}.must_raise ArgumentError

      proc{@administrator.reserve_a_room(Date.new(2017,2,3), 3, nil)}.must_raise ArgumentError
    end

    it "raises an error if room is on hold for a block" do
      block = @administrator.create_block(Date.new(2017,3,10), 2, 2)
      rooms = block.rooms

      proc { @administrator.reserve_a_room(Date.new(2017,3,10), 1, rooms[0]) }.must_raise ArgumentError

      proc { @administrator.reserve_a_room(Date.new(2017,3,10), 1, rooms[1]) }.must_raise ArgumentError

    end

  end

  describe "create_block method" do

    before do
      @administrator = Hotel::Administrator.new
      @block = @administrator.create_block(Date.new(2017,3,10), 3, 4)

    end

    it "is an instance of Block" do
      @block.must_be_kind_of Hotel::Block
    end

    it "establishes the base data structures when block is instantiated" do
      [:block_id, :start_date, :number_of_nights, :rooms, :reservations].each do |prop|
        @block.must_respond_to prop
      end

      @block.block_id.must_be_kind_of Integer
      @block.start_date.must_be_kind_of Date
      @block.number_of_nights.must_be_kind_of Integer
      @block.rooms.must_be_kind_of Array
      @block.reservations.must_be_kind_of Array

    end

    it "assigns a unique block_id" do
      @block.block_id.must_equal 1
    end

    it "assigns x number of rooms based on num_rooms indicated" do
      @block.rooms.length.must_equal 4

      all_rooms = @block.rooms.all? { |room| room.class == Hotel::Room }
      all_rooms.must_equal true
    end

    it "adds block to administrator collection of blocks" do
      @administrator.blocks.must_include @block
      @administrator.blocks.length.must_equal 1
    end

    it "adds the block to the collection of blocks for each room" do
      all_rooms = @block.rooms.all? { |room| room.blocks.include? @block }
      all_rooms.must_equal true

    end

    it "raises error if no rooms are available for that date range" do
      new_admin = Hotel::Administrator.new
      i = 0
      # regular reservations
      15.times do
        new_admin.reserve_a_room(Date.new(2017,3,12), 3, i += 1)
      end

      # rooms that are part of block

      new_admin.create_block(Date.new(2017,3,12), 3, 5)

      # assertion
      proc { new_admin.create_block(Date.new(2017,3,12), 3, 3) }.must_raise ArgumentError

    end

    it "raises an error if num_rooms is greater than 5 or less than 1" do
      proc { @administrator.create_block(Date.new(2017,5,16), 3, 7) }.must_raise ArgumentError

      proc { @administrator.create_block(Date.new(2017,5,16), 3, 0) }.must_raise ArgumentError
    end

    it "raises an error if start_date is not Date object" do
      proc { @administrator.create_block(-3, 2, 3) }.must_raise ArgumentError
    end

    it "raises an error is number_of_nights entered is less than 1 or not an integer" do
      proc { @administrator.create_block(Date.new(2017,4,28), 0, 3) }.must_raise ArgumentError

      proc { @administrator.create_block(Date.new(2017,4,28), 3.3, 4) }.must_raise ArgumentError
    end

  end

  describe "reserve_room_from_block method" do
    before do
      @administrator = Hotel::Administrator.new

      @block = @administrator.create_block(Date.new(2017,4,28), 3, 4)

      #block id is equal to 1

      @first_reservation = @administrator.reserve_room_from_block(1)

      @reserved_room = @first_reservation.room
    end

    it "creates new reservation for specific block" do

      @first_reservation.must_be_kind_of Hotel::Reservation

      [:reservation_id, :start_date, :number_of_nights, :room, :block_of_dates, :room_rate, :check_out_date].each do |prop|
        @first_reservation.must_respond_to prop
      end

    end

    it "adds reservation to reservation collection of the block" do
      @block.reservations.must_include @first_reservation
      @block.reservations.length.must_equal 1
    end

    it "adds reservation to the reservation collection of the room" do
      @reserved_room.reservations.must_include @first_reservation
    end

    it "add reservations to the reservation collection of the administrator" do
      @administrator.reservations.must_include @first_reservation
    end

    it "gives a discount of $25 per night for the room rate" do
      @first_reservation.room_rate.must_equal 175.00
      @first_reservation.total_cost.must_equal 525.00
    end

    it "saves the reservation dates as the same date range of the block" do
      @first_reservation.block_of_dates.must_equal @block.dates_of_block
    end

    it "raises an argument error if all rooms from block are reserved" do
      # num rooms in block 1 are 4 rooms
      # reserving 3 more to book all
      3.times do
        @administrator.reserve_room_from_block(1)
      end

      proc { @administrator.reserve_room_from_block(1) }.must_raise ArgumentError
    end

    it "raises an error if block id does not exist" do
      proc { @administrator.reserve_room_from_block(223) }.must_raise ArgumentError
    end

  end

  describe "rooms_from_block_available?(block_id) method" do

    before do
      @administrator = Hotel::Administrator.new

      # block ID is 1 since its first block
      @administrator.create_block(Date.new(2017,4,28), 3, 4)

      3.times do
        @administrator.reserve_room_from_block(1)
      end
    end

    it "returns true if given block has rooms available for reservation" do
      @administrator.rooms_from_block_available?(1).must_equal true
    end

    it "returns false if given block has no rooms avaialable for reservation" do
      # reserving last room from block 1
      @administrator.reserve_room_from_block(1)

      @administrator.rooms_from_block_available?(1).must_equal false
    end

    it "raises an argument error if block id does not exist" do
      proc { @administrator.rooms_from_block_available?(223) }.must_raise ArgumentError
    end

  end



end
