
require 'time'
require 'pry'
require 'awesome_print'

require_relative 'room'
require_relative 'reservation'

module Hotel
  class Administrator

    attr_reader :rooms, :reservations

    def initialize
      @rooms = room_list
      @reservations = []
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

      rooms.select { |room| room.booked_nights == nil || room.booked_nights.include?(searched_dates) }

    end

    def reserve_a_room(date, number_of_nights, room_id)

      check_date(date)
      check_number_of_nights(number_of_nights)

      room = find_room(room_id)
      searched_dates = convert_to_dates(date, number_of_nights)
      booked_nights = room.booked_nights

      if overlap?(searched_dates, booked_nights)
        raise ArgumentError.new("Room is not available to book during these dates.")
      else

        reservation_id = reservations.length + 1

        new_reservation = Reservation.new(reservation_id, date, number_of_nights, room)
        room.add_reservation(new_reservation)
        reservations << new_reservation
      end
      return new_reservation

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

    def overlap?(searched_dates, booked_nights)
      if booked_nights == nil
        false
      else
        searched_dates.any? {|date| booked_nights.include?(date) } ? true : false
      end
    end

  end

end
#
administrator = Hotel::Administrator.new
reservation = administrator.reserve_a_room(Date.new(2017,2,7), 5, 9)
second_reservation = administrator.reserve_a_room(Date.new(2017,2,7), 5, 10)
third = administrator.reserve_a_room(Date.new(2017,2,6), 5, 11)


room = administrator.find_room(9)
# #
# # # puts "#{reservation.block_of_dates}"
# # # puts
available_rooms = administrator.show_rooms_available(Date.new(2017,2,7), 2)

available_rooms.each do |room|
  puts room.room_id
end

# puts "#{room.booked_nights}"
# puts "#{reservation.block_of_dates}"
# puts administrator.rooms
# puts "#{administrator.rooms}"
