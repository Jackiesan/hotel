
require 'time'
require 'pry'
require 'awesome_print'

require_relative 'room'
require_relative 'reservation'
require_relative 'block'

module Hotel
  class Administrator

    attr_reader :rooms, :reservations, :blocks

    def initialize
      @rooms = room_list
      @reservations = []
      @blocks = []
    end

    def room_list
      room_ids = (1..20).to_a
      room_list = []
      room_ids.each do |room_id|
        room_list << Room.new(room_id)
      end
      return room_list
    end

    def find_room(room_id)
      check_room_id(room_id)
      @rooms.find{ |room| room.room_id == room_id}
    end

    def reservations_on_date(date)
      check_date(date)

      reservations.select { |reservation| (reservation.check_out_date == date) ||  (reservation.block_of_dates.include?(date) == true) }
    end

    def show_rooms_available(date, number_of_nights)
      check_date(date)
      check_number_of_nights(number_of_nights)

      searched_dates = convert_to_dates(date, number_of_nights)

      rooms.reject { |room| overlap?(searched_dates, room.unavailable_nights)}

    end

    def reserve_a_room(date, number_of_nights, room_id)

      check_date(date)
      check_number_of_nights(number_of_nights)

      room = find_room(room_id)
      searched_dates = convert_to_dates(date, number_of_nights)
      rooms_unavailable_nights = room.unavailable_nights

      if overlap?(searched_dates, rooms_unavailable_nights)
        raise ArgumentError.new("Room is not available to book during these dates.")
      else

        reservation_input = {
          reservation_id: reservations.length + 1,
          start_date: date,
          number_of_nights: number_of_nights,
          room: room,
          block_of_dates: searched_dates,
          room_rate: 200.00
        }

        new_reservation = Reservation.new(reservation_input)
        room.add_reservation(new_reservation)
        reservations << new_reservation
      end
      return new_reservation

    end

    def create_block(start_date, number_of_nights, num_rooms)
      check_date(start_date)
      check_number_of_nights(number_of_nights)
      check_num_of_rooms(num_rooms)

      rooms_available = show_rooms_available(start_date, number_of_nights)

      if rooms_available.length < num_rooms
        raise ArgumentError.new("Not enough rooms are available for block creation. Number of rooms entered: #{num_rooms}")
      else

        rooms = rooms_available[0...num_rooms]


        block_info = {
          block_id: blocks.length + 1,
          start_date: start_date,
          number_of_nights: number_of_nights,
          rooms: rooms
        }

        new_block = Block.new(block_info)
        rooms.each do |room|
          room.add_block(new_block)
        end
        @blocks << new_block
        return new_block
      end
    end

    # def find_block(block_id)
    #   check_block_id(block_id)
    #
    #   return @blocks.find{ |block| block.block_id == block_id}
    #
    # end

    def reserve_room_from_block(block_id)
      check_block_id(block_id)

      block = find_block(block_id)

      if block.reservations.length == block.rooms.length
        raise ArgumentError.new("There are no available rooms left for this block")
      else

        room = block.rooms.first

        new_reservation_info = {
          reservation_id: reservations.length + 1,
          start_date: block.start_date,
          number_of_nights: block.number_of_nights,
          room: room,
          block_of_dates: block.dates_of_block,
          room_rate: 175.00
        }


        new_reservation = Hotel::Reservation.new(new_reservation_info)

        block.add_reservation(new_reservation)
        room.add_reservation(new_reservation)
        reservations << new_reservation

        return new_reservation

      end
    end

    def rooms_from_block_available?(block_id)
      block = find_block(block_id)

      if block.rooms.length == block.reservations.length
        return false
      else
        return true
      end

    end

    private

    def check_date(date)
      if date.class != Date
        raise ArgumentError.new("Date entered is not valid date (got #{date})")
      end
    end

    def check_number_of_nights(number_of_nights)
      if number_of_nights.class != Integer || number_of_nights < 1
        raise ArgumentError.new("Number of nights not valid. Minimum stay is at least 1 night (got #{number_of_nights})")
      end
    end

    def check_room_id(room_id)
      if room_id.class != Integer || room_id < 1 || room_id > 20
        raise ArgumentError.new("Room ID entered does not exist (got #{room_id})")
      end
    end

    def convert_to_dates(date, number_of_nights)
      dates = [date]
      i = 0
      (number_of_nights - 1).times do
        i += 1
        dates << date + i
      end
      return dates
    end

    def overlap?(searched_dates, unavailable_nights)
      if unavailable_nights.length == 0
        return false
      else
        searched_dates.any? {|date| unavailable_nights.include?(date) } ? true : false
      end
    end

    def check_block_id(block_id)
      if block_id.class != Integer || block_id < 1 || block_id > blocks.length
        raise ArgumentError.new("Block ID entered is not valid (got #{block_id})")
      end
    end

    def check_num_of_rooms(num_rooms)
      if num_rooms.class != Integer || num_rooms < 1 || num_rooms > 5
        raise ArgumentError.new("Number of rooms entered is not valid (got #{num_rooms})")
      end
    end

    def find_block(block_id)
      check_block_id(block_id)

      return @blocks.find{ |block| block.block_id == block_id}

    end

  end

end

administrator = Hotel::Administrator.new

puts administrator.reservations_on_date(Date.new(2017,3,10)).class
