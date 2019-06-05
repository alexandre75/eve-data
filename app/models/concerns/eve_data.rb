module EveData
  extend ActiveSupport::Concern

  def self.region_history(params)
    Rails.logger.info("EveData.region_history : " + params.to_s)
    @region = Region.find_by!(eve_id: params[:region_id])
    hist = @region.histories.find_by(item: params[:id])

    threshold = Date.today.prev_day(2)
    if hist && (hist.updated_at <=> threshold) == 1
      return hist
    else
      History.create_from_hist(params, hit_eve(eve_params(params)))
    end
  end

  def self.hit_eve(params)
    Rails.logger.info("EveData.hit_eve : " + params.to_s)
    response = Faraday.get("https://esi.evetech.net/latest/markets/#{params[:region_id]}/history/?", {type_id: params[:type_id]})
    if response.success?
      JSON.parse(response.body).map {|hist| create_hist(hist) }.to_a
    else
      Rails.logger.error("https://esi.evetech.net/latest/markets/" + response.status.to_s + "/" + response.body)
      raise "Eve server does not have the resource : " + params.to_s
    end
  end
  
  def self.eve_params(params)
    { region_id: params[:region_id], type_id: params[:item] }
  end

  
  def self.create_hist(hist)
    OpenStruct.new(average: hist["average"],
                   date: hist["date"],
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
