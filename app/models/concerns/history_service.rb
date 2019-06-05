require 'eve_data.rb'

module HistoryService
  extend ActiveSupport::Concern

  LOGGER = Rails.logger
  
  def self.region_history(params)
    Rails.logger.info("HistoryService.region_history : " + params.to_s)
    @region = Region.find(params[:region_id])
    hist = @region.histories.find_by(item: params[:item])
    LOGGER.debug("From DB :" + hist.to_s)
    threshold = Date.today.prev_day(2)
    if hist && (hist.updated_at <=> threshold) == 1
      return hist
    else
      fetch_and_save(params)
    end
  end

  def self.fetch_and_save(params)
    markets_history = EveData.markets_history(eve_params(params))
    history = History.of(params, markets_history)
    history.save
  end
   
  def self.eve_params(params)
    { region_id: @region.eve_id, type_id: params[:item] }
  end
end
