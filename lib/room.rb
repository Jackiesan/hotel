require 'time'
require 'pry'
require 'awesome_print'

require_relative 'block'

module Hotel

  class Room

    attr_reader :room_id, :reservations

    def initialize(room_id)
     @room_id = room_id
     @reservations = []
    end

    def add_reservation(reservation)
      if reservation.class != Hotel::Reservation
        raise ArgumentError.new("Can only add a Room instance to reservation collection")
      end

      @reservations << reservation
    end

    def booked_nights

      if reservations.empty?
        return []
      else
        not_available = []
      reservations.each do |reservation|
          not_available << reservation.block_of_dates
        end

        return not_available.flatten!

      end

    end

  end
end
