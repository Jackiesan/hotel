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
      @room = [:room]
      @block_of_dates = [:dates]
    end

    def total_cost
      return 200.00 * @number_of_nights
    end

    def dates
      dates = [date]
      i = 0
      (number_of_nights - 1).times do
        i += 1
        dates << date + i
      end
      return dates
    end



  end
end
