require 'time'
require 'pry'
require 'awesome_print'
require 'time'


module Hotel
  class Reservation

    attr_reader :reservation_id, :date, :number_of_nights, :room

    def initialize(reservation_id, date, number_of_nights, room)
      @reservation_id = reservation_id
      @date = date
      @number_of_nights = number_of_nights
      @room = room
    end

    def total_cost
      return 200.00 * @number_of_nights
    end

  end
end
