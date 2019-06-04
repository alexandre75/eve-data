require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  test "save and fetch" do
    @one = histories(:one)
    
    @one.save

    region = regions(:domain)
    may_be_one = History.find_by(item: 1, region: region)
    assert_equal @one, may_be_one
  end
end
