
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

      room_ids = (0..20).to_a
      room_list = []
      room_ids.each do |room_id|
        room_list << Room.new(room_id)
      end
      return room_list
    end

    def reservation_list #date
      return @reservations
    end

    def reserve_a_room(date, number_of_nights, room_id)
      @reservations << Reservation.new(date, number_of_nights, room_id)
    end

  end

end
