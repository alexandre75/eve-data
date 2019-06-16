module EveData
  
  def self.markets_history(params)
    Rails.logger.info("EveData.market_history : " + params.to_s)
    response = Faraday.get("https://esi.evetech.net/latest/markets/#{params[:region_id]}/history/?", {type_id: params[:type_id]})
    if response.success?
      JSON.parse(response.body).map {|hist| create_hist(hist) }.to_a
    else
      Rails.logger.error("https://esi.evetech.net/latest/markets/" + response.status.to_s + "/" + response.body)
      raise NotFoundError.new("Eve server does not have the resource : " + params.to_s)
    end
  end
  
  def self.create_hist(hist)
    OpenStruct.new(average: hist["average"],
                   date: Date.parse(hist["date"]),
                   highest: hist["highest"],
                   lowest: hist["lowest"],
                   order_count: hist["order_count"],
                   volume: hist["volume"])
  end

  def self.build_market_summary(parameters)
    Rails.logger.info("Fetching orders for region #{parameters.to_s}")
    parameters[:connection] = Faraday.new('https://esi.evetech.net/latest')
    orders = Orders.new (parameters)
    summaries = Summaries.new
    summaries.process(orders)
    summaries.to_a
  end
end

class NotFoundError < StandardError

end
