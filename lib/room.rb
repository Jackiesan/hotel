require 'time'
require 'pry'
require 'awesome_print'


module Hotel

  class Room

    attr_reader :room_id, :cost

    def initialize(room_id)
     @room_id = room_id
     @cost = 200
    end

  end
end
