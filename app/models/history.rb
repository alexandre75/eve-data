class History < ApplicationRecord
  belongs_to :region

  validates :quantity, presence: true
  validates :median, presence: true
  validates :item, presence: true

  LOGGER = Rails.logger
  
  def self.of(history_params, eve_history)
    if eve_history.empty?
      return self.new( { :quantity => 0, :median => 0 }.merge(history_params) )
    else
      date_range = one_month(eve_history)
      LOGGER.debug("date_range : " + date_range.to_s)
      sample = comp_sample(eve_history, date_range)
      LOGGER.debug("sample : " + sample.to_s)
      
      quantity = sample.map {|hist| hist.volume }.sum(0.0)
      
      median_price = comp_sell_price(sample, date_range, quantity)
      # daily quantities used to be weighted by proximity with avg : 0 when avg = high, 1 when avg = high 
      
      history = { quantity: quantity  / (date_range[1] - date_range[0]),
                  median: median_price }.merge(history_params)
      puts history.to_s
      self.new(history)
    end
  end

  def self.one_month(eve_history)
    latest_date = eve_history.map { |hist| hist.date }.max
    month_ago = latest_date << 1
    [month_ago, latest_date]
  end
  
  def self.comp_sample(eve_history, date_range)
    eve_history.select { |hist| (hist.date <=> date_range[0]) == 1 }
               .sort { |hist1, hist2| hist1.average <=> hist2.average }
  end

  # Calculates  a median of average. I now think that it makes more sense
  # because the higher the spread the higher the risk so better use average
  # even if it is not a seller price.
  # Previous calculation was to compare with the Jta buy price :
  # * Use low price if it is > jita
  # * else use priceHigh
  def self.comp_sell_price(sample, date_range, volume)
    LOGGER.debug("volume : " + volume.to_s)
    qty = 0
    price = 0.0
    sample.each do |hist|
      if (qty + hist.volume) > volume / 2
        price = hist.average
        break;
      end
      qty += hist.average
    end
    sample.each do |hist|
      if (qty + hist.volume) > (volume + 1) / 2
        price += hist.average
        break;
      end
      qty += hist.average
    end
    price / 2.0
  end
end
