require 'test_helper'

class HttpDouble
  def initialize(params)
    @page_max = params[:page] || 2
    file = File.read("test/fixtures/orders1.json")
    @json = file
  end
  
  def get(ignored, params)
    @page = params[:page]
    self
  end

  def success?
    true
  end

  def body
    if @page.to_i <= @page_max
      @json
    else
      '[]'
    end
  end
end

class OrdersTest < MiniTest::Unit::TestCase

  def test_station
    orders = Orders.new ({ region_id: 1, station_id: 60005599, connection: HttpDouble.new({})})
    result = []
    orders.each { |order| result << order }

    assert_equal(4, result.size)
    assert_equal(34, result[0]["type_id"])
  end

  def test_region
    orders = Orders.new ({ region_id: 1, connection: HttpDouble.new({})})
    result = []
    orders.each { |order| result << order }

    assert_equal(4, result.size)
    assert_equal(34, result[0]["type_id"])
  end
  
  def test_empty
    orders = Orders.new ({ region_id: 1, station_id: 2, connection: HttpDouble.new({ page: 0}) })
    result = []
    orders.each { |order| result << order }

    assert_equal(0, result.size)
  end
end
