require 'time'
require 'pry'
require 'awesome_print'

require_relative 'block'

module Hotel

  class Room

    attr_reader :room_id, :reservations, :blocks

    def initialize(room_id)
     @room_id = room_id
     @reservations = []
     @blocks = []
    end

    def add_reservation(reservation)
      if reservation.class != Hotel::Reservation
        raise ArgumentError.new("Can only add a Room instance to reservation collection")
      end

      reservations << reservation
    end

    def add_block(block)
      if block.class != Hotel::Block
        raise ArgumentError.new("Can only add a Block instance to block collection")
      end

      blocks << block
    end

    def unavailable_nights

      if reservations.empty? && blocks.empty?
        return []
      else
        not_available = []

        reservations.each do |reservation|
          not_available << reservation.block_of_dates
        end

        blocks.each do |block|
          not_available << block.dates_of_block
        end

        return not_available.flatten!

      end

    end

  end
end
