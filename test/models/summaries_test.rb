require 'test_helper'

class SummariesTest < MiniTest::Unit::TestCase
  def setup
    file = File.read("test/fixtures/orders1.json")
    @orders = JSON.parse(file)
  end
  
  def test_process_orders
    summs = Summaries.new
    summs.process(@orders)

    summ = summs.to_a[0]
    assert_equal(34, summ.type_id)
    assert_equal(2, summ.bid_size)
    assert_equal(2, summ.size)
    assert_in_delta(5, summ.bid, 0.01)
    assert_equal(0, summ.nb_active_trader)
  end
end
