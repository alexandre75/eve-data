require 'orders.rb'

class TradersController < ApplicationController

  def index
    book_params = add_region(permitted)
    order_books = EveData.build_market_summary(book_params)
    render json: order_books, status: :ok, except: [:active_window]
    expires_in 1.hours, public: true
  end

  def permitted
    params.permit(:region_id, :station_id)
  end

  def add_region(params)
    if !params[:region_id]
      station = Station.find_by(eveid: params[:station_id])
      Rails.logger.debug("Found region : " + station.region.eve_id)
      hash = {region_id: station.region.eve_id}
      hash.merge(traders_scope)
    else
      Rails.logger.debug("Region was in params")
      params
    end
  end
end
