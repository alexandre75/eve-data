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
    parameters[:connection] = Faraday.new(url: 'https://esi.evetech.net/latest',
                                          headers: {'Authorization' => 'Bearer ' + token(Time.new)})
    orders = Orders.new (parameters)
    summaries = Summaries.new
    summaries.process(orders)
    summaries.to_a
  end

  REFRESH_URL="https://login.eveonline.com/v2/oauth/token"
  REFRESH_PAYLOAD='{ "grant_type":"refresh_token", "refresh_token":"gzukkp-2T8S2QE7B85XPylA0b_J_o3kvFvYumJpdfg4" }'
  REFRESH_HEADERS={ "Authorization": "Basic XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==", "Content-Type": "application/json" }
  
  def self.refresh_token
    resp = Faraday.post(REFRESH_URL, REFRESH_PAYLOAD, REFRESH_HEADERS)
    JSON.parse(resp.body)["access_token"]
  end

  @@cached_token = nil
  @@last_refresh = nil
  
  def self.token(now)
    if !@@last_refresh || now - 1100 > @@last_refresh 
      @@cached_token = refresh_token
      @@last_refresh = now
    end
    
    return @@cached_token
  end
end

class NotFoundError < StandardError

end
