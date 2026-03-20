
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
    page = 1
    total_pages = nil

    loop do
      response = conn.get orders_path, { page: page.to_s, order_type: "sell" }
      
      if response.success?
        # Get the total pages from headers on the first request
        total_pages ||= response.headers['x-pages'].to_i
        
        orders = JSON.parse(response.body)
        break if orders.empty?
        
        orders.each do |order|
          yield(order) if !station_id || station_id == order["location_id"].to_i
        end
        
        # Stop if we just finished the last known page
        break if page >= total_pages
        page += 1
      else
        # Handle actual errors (like 500s), but treat 404 as "End of Data"
        break if response.status == 404
        raise FailedDependencyError
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
