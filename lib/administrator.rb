
require 'time'
require 'pry'
require 'awesome_print'

require_relative 'room'

module Hotel
  class Administrator

    attr_reader :rooms, :reservations

    def initialize
      @rooms = room_list
      @reservations = reservation_list
    end

    def room_list

      room_ids = (0..20).to_a
      room_list = []
      room_ids.each do |room_id|
        room_list << Room.new(room_id)
      end
      return room_list
    end

    def reservation_list

    end

  end

end

administrator = Hotel::Administrator.new
puts administrator.room_list
