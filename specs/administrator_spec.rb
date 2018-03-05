require_relative 'spec_helper'

describe "Administrator class" do

  describe "Administrator instantiation" do

    before do
      @administrator = Hotel::Administrator.new
    end

    it "is an instance of Administrator" do
      @administrator.must_be_kind_of Hotel::Administrator
    end

    it "establishes the base data structures when instantiated" do
      [:rooms, :reservations].each do |prop|
        @administrator.must_respond_to prop
      end

      @administrator.rooms.must_be_kind_of Array
      @administrator.reservations.must_be_kind_of Array

    end

  end

end
