class History < ApplicationRecord
  belongs_to :region

  validates :quantity, presence: true
  validates :median, presence: true
  validates :item, presence: true

  def self.create_from_hist(history_params, eve_hist)
    to_add = History.new( volume_price(eve_hist).merge(history_params) )
    to_add.save 
    to_add
  end

  def self.volume_price(eve_hist)
    month_ago = Date.today.prev_month
    sample = eve_hist.select { |hist| (hist.date <=> month_ago) != -1 }
                          .sort { |hist1, hist2| hist1.average <=> hist2.average }
    median_price = (sample[(sample.size - 1) / 2].average + sample[sample.size / 2].average) / 2.0
    quantity = sample.map {|hist| hist.volume }.sum(0.0) / sample.length
    { quantity: quantity, median: median_price }
  end
end
