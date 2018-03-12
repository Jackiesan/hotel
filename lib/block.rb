require 'time'
require 'pry'
require 'awesome_print'

module Hotel

  class Block

    attr_reader :block_id, :start_date, :number_of_nights, :rooms, :reservations

    def initialize(input)
      @block_id = input[:block_id]
      @start_date = input[:start_date]
      @number_of_nights = input[:number_of_nights]
      @rooms = input[:rooms]
      @reservations = []
    end


    def dates_of_block
      dates = [start_date]
      i = 0
      (number_of_nights - 1).times do
        i += 1
        dates << start_date + i
      end
      return dates
    end

    def add_reservation(reservation)
      if reservation.class != Hotel::Reservation
        raise ArgumentError.new("Can only add a Reservations instance to reservations collection")
      else

        reservations << reservation
      end
    end

  end
end
