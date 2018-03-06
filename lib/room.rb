require 'time'
require 'pry'
require 'awesome_print'


module Hotel

  class Room

    attr_reader :room_id, :cost_per_night, :status

    def initialize(room_id, status: :AVAILABLE)
     @room_id = room_id
     @cost_per_night = 200.00
     @status = status
    end

  end
end
