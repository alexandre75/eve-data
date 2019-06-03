require 'eve_data.rb'

class BooksController < ApplicationController
  
  def index
    @region = region_smart_find(params[:region_id])
    @station = station_smart_find(@region, params[:station_id])
    order_books = EveData.build_market_summary station_id: @station.eveid, region_id: @region.eve_id
    render json: order_books, status: :ok, except: [:active_window]
    expires_in 1.hours, public: true
  end

  # hack in order to be able to use surrogate key
  def region_smart_find(an_id)
    if an_id.to_i > 1000
      Region.find_by(eve_id: an_id)
    else
      Region.find(an_id)
    end
  end

  # hack in order to be able to use surrogate key
  def station_smart_find(region, an_id)
    if an_id.to_i > 1000
      Station.find_by(eveid: an_id)
    else
      region.stations.find(an_id)
    end
  end
end
