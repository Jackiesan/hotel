require 'time'
require 'pry'
require 'awesome_print'


module Hotel
  class Room

    attr_reader :id
    
    def initialize(id)
      @id = id
    end

  end
end
