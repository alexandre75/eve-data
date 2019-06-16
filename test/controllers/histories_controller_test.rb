require 'test_helper'

class HistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @history1 = histories(:one)
  end
  
  test "should get get" do
    get "/regions/10000010/histories/1"
    assert_response :success
    puts @response
  end

  test "should get from eve" do
    get "/regions/10000042/histories/11859"
    assert_response :success
    puts @response
  end

  test "MarketData consumer test" do
    get "/regions/10000042/histories/11859"
    assert_response :success

    json = JSON.parse(@response.body)
    assert(json["quantity"])
    assert(json["median"])
  end

  test "should return 404" do
    get "/regions/10000042/histories/45736"
    assert_response :missing
  end
end
