require 'time'
require 'pry'
require 'awesome_print'
require 'time'


module Hotel
  class Reservation

    attr_reader :reservation_id, :start_date, :number_of_nights, :room, :block_of_dates, :room_rate, :check_out_date

    def initialize(input)
      @reservation_id = input[:reservation_id]
      @start_date = input[:start_date]
      @number_of_nights = input[:number_of_nights]
      @room = input[:room]
      @block_of_dates = input[:block_of_dates]
      @room_rate = input[:room_rate]
      @check_out_date = block_of_dates.last + 1
    end

    def total_cost
      return room_rate * @number_of_nights
    end

  end
end
