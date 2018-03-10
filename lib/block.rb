require 'time'
require 'pry'
require 'awesome_print'

module Hotel

  class Block

  attr_reader :block_id, :start_date, :number_of_nights, :rooms

  def initialize(input)
    @block_id = input[:block_id]
    @start_date = input[:start_date]
    @number_of_nights = input[:number_of_nights]
    @rooms = input[:rooms]
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

  end
end
