
class Summaries
  attr_reader :summaries, :count
  def initialize
    active_window =  Date.today.prev_day(2)
    @summaries = Hash.new { |hash, type_id| hash[type_id] = Summary.new(type_id, active_window) }
    @count = 0
  end
  
  def process(orders)
    orders.each { |order| process_order(order)}
  end

  def to_a
    Rails.logger.debug "Analysed " + count.to_s + " orders..."
    summaries.values
  end

  def process_order(order)
    @count += 1
    type_id = order["type_id"].to_i
    summaries[type_id] << order
  end
end

class Summary
  attr_reader :type_id, :nb_active_trader, :bid, :size,:bid_size
  def initialize(type_id, active_window)
    @type_id = type_id
    @nb_active_trader = 0
    @size = 0
    @active_window = active_window
    @bid_size = 0
  end

  def <<(order)
    @size += 1
    if order["is_buy_order"] == false
      @bid_size += 1
      @bid = order["price"] if !bid || order["price"] < bid
      @nb_active_trader += 1 if active_trader(order)
    end
  end

  def active_trader(order)
  order_date = Date.parse(order["issued"])
  (order_date <=> @active_window) == 1
  end
end
