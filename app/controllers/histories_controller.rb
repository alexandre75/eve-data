require 'eve_data.rb'

class HistoriesController < ApplicationController
  include EveData
  
  def index
  end
  
  def show
    @hist = from_db_then_http
    expires_in 1.days, public: true
    render json: @hist, status: :ok
  end

  def from_db_then_http
    @region = Region.find_by!(eve_id: params[:region_id])
    hist = @region.histories.find_by(item: params[:id])

    threshold = Date.today.prev_day(2)
    if hist && (hist.updated_at <=> threshold) == 1
      Rails.logger.info(hist.to_s)
      return hist
    else
      hit_eve
    end
  end

  def hit_eve
    eve_hist = EveData.region_history(region_history_params)
    History.create_from_hist(history_params, eve_hist)
  end
  
  def region_history_params
    { region_id: params[:region_id], type_id: params[:id] }
  end

  def history_params
    { region_id: params[:region_id], item: params[:id] }
  end
end
