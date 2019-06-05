require 'eve_data.rb'

class HistoriesController < ApplicationController
  include EveData
  
  def index
  end
  
  def show
    @hist = EveData.region_history(history_params)
    expires_in 1.days, public: true
    render json: @hist, status: :ok
  end

  def history_params
    { region_id: params[:region_id], item: params[:id] }
  end
end
