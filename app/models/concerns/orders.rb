
class Orders
  attr_reader :region_id, :station_id, :conn
  def initialize(params)
    @region_id = params[:region_id]
    raise ArgumentError, "region_id missing" unless @region_id
    @station_id = params[:station_id].to_i if params[:station_id]
    @conn = params[:connection]
    raise "AssertionError" unless @conn
  end   

  def each
    page=1
    attempt = 1
    #conn.token_auth('')
    loop do
      Rails.logger.debug("requesting page : #{page}")
      Rails.logger.debug("Path " + orders_path.to_s)
      response = conn.get orders_path, {page: page.to_s, order_type: "sell"}      
      if response.success? then
        orders = JSON.parse(response.body)
        break if orders.empty?
        orders.each do |order|
          yield(order) if !station_id || station_id == order["location_id"].to_i
        end
        page += 1
        attempt = 1
      else
        raise FailedDependencyError if attempt == 3
        Rails.logger.warn(conn.to_s)
        Rails.logger.warn(response.body)
        attempt += 1
      end
    end
  end

  def orders_path
    if region_id == "10000039"
      "markets/structures/1024004680659/"
    else
      "markets/#{region_id}/orders/"
    end
  end
end
