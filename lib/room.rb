require 'time'
require 'pry'
require 'awesome_print'


module Hotel

  class Room

    attr_reader :room_id, :cost_per_night

    def initialize(room_id)
     @room_id = room_id
     @cost_per_night = 200.00
    end

  end
end
