require 'time'
require 'pry'
require 'awesome_print'
require 'time'


module Hotel
  class Reservation

    attr_reader :reservation_id, :date, :number_of_nights, :room, :block_of_dates

    def initialize(input)
      @reservation_id = input[:reservation_id]
      @date = input[:date]
      @number_of_nights = input[:number_of_nights]
      @room = input[:room]
      @block_of_dates = input[:block_of_dates]
    end

    def total_cost
      return 200.00 * @number_of_nights
    end

  end
end
