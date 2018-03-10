require 'time'
require 'pry'
require 'awesome_print'

module Hotel

  class Block

  attr_reader :block_id, :date, :number_of_nights, :rooms

  def initialize(input)
    @block_id = input[:block_id]
    @date = input[:date]
    @number_of_nights = input[:number_of_nights]
    @rooms = []
  end

  end
end
