require 'test_helper'

class EveDataTest < MiniTest::Unit::TestCase
  def test_refresh_token
    new_token = EveData.refresh_token
    p new_token
    refute_empty(new_token)
  end

  def test_token_cache
    time = Time.new(2020, 7,26, 2, 0)
    token = EveData.token(time)
    refute_nil(token)
  end
  
  def test_token_cache
    time = Time.new(2020, 7,26, 2, 0)
    token = EveData.token(time)

    time2 = Time.new(2020, 7,26, 2, 10)
    new_token = EveData.token(time2)

    assert_equal(token, new_token)
  end

 def test_token_cache_invalidate
    time = Time.new(2020, 7,26, 2, 0)
    token = EveData.token(time)

    time2 = Time.new(2020, 7,26, 2, 20)
    new_token = EveData.token(time2)

    refute_equal(token, new_token)
  end
  
end
