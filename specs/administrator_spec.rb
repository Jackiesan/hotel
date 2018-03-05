require_relative 'spec_helper'

describe "Administrator class" do

  describe "Administrator instantiation" do

    it "is an instance of Administrator" do
      administrator = Hotel::Administrator.new
      administrator.must_be_kind_of Hotel::Administrator
    end

  end
  
end
