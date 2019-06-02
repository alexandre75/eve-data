require 'eve_data.rb'

class BooksController < ApplicationController
  
  def index
    @region = Region.find(params[:region_id])
    @station = @region.stations.find(params[:station_id])
    order_books = EveData.build_market_summary station_id: @station.eveid, region_id: @region.eve_id
    render json: order_books, status: :ok, except: [:active_window]
    expires_in 1.hours, public: true
  end
end
