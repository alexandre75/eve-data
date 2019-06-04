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

end
