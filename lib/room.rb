require 'time'
require 'pry'
require 'awesome_print'


module Hotel

  class Room

    attr_reader :room_id, :reservations, :booked_nights

    def initialize(room_id)
     @room_id = room_id
     @reservations = []
     @booked_nights = booked_nights
    end

    def add_reservation(reservation)
      if reservation.class != Hotel::Reservation
        raise ArgumentError.new("Can only add a Room instance to reservation collection")
      end

      @reservations << reservation
    end

    def booked_nights
      not_available = []
      @reservations.each do |reservation|
        not_available << reservation.block_of_dates
      end
      return not_available[0]

    end

  end
end
