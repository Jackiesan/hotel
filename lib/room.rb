require 'time'
require 'pry'
require 'awesome_print'


module Hotel
  class Room

    attr_reader :room_id

    def initialize(room_id)
      @room_id = room_id
    end

  end
end
