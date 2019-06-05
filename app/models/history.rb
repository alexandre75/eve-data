class History < ApplicationRecord
  belongs_to :region

  validates :quantity, presence: true
  validates :median, presence: true
  validates :item, presence: true

  def self.of(history_params, eve_history)
    month_ago = Date.today.prev_month
    sample = eve_history.select { |hist| (hist.date <=> month_ago) != -1 }
                          .sort { |hist1, hist2| hist1.average <=> hist2.average }
    median_price = (sample[(sample.size - 1) / 2].average + sample[sample.size / 2].average) / 2.0
    quantity = sample.map {|hist| hist.volume }.sum(0.0) / sample.length
    history = { quantity: quantity, median: median_price }.merge(history_params)
    puts history.to_s
    self.new(history)
  end
end
