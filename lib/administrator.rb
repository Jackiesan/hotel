
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

      reservations.select { |reservation| reservation.block_of_dates.include?(date) == true }
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
          date: date,
          number_of_nights: number_of_nights,
          room: room,
          block_of_dates: searched_dates,
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
      return new_block
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

  end

end


administrator = Hotel::Administrator.new

block = administrator.create_block(Date.new(2017,3,10), 2, 2)
puts block
block.rooms.each do |room|
  puts room
  puts room.room_id
end

puts "dates of block: #{block.dates_of_block}"
puts
room_1 = administrator.find_room(1)
room_2 = administrator.find_room(2)

puts room_1.blocks
puts room_2.blocks
puts "reserved_nights: #{room_1.unavailable_nights}"
