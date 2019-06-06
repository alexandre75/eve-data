require 'test_helper'
require 'eve_data.rb'

class HistoryTest < ActiveSupport::TestCase
  test "save and fetch" do
    @one = histories(:one)
    
    @one.save

    region = regions(:domain)
    may_be_one = History.find_by(item: 1, region: region)
    assert_equal @one, may_be_one
  end

  test "of history" do
    history_json = JSON.parse(File.read('test/models/history.json'))
    eve_history = history_json.map { |o| EveData.create_hist(o) }

    history = History.of({}, eve_history)

    assert_in_delta(6.45E-2, history[:quantity], 1E-4)
    assert_in_delta(1.64E8, history[:median], 1E6)
  end
end
