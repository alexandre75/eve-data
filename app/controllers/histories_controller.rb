
class HistoriesController < ApplicationController
  include EveData
  
  def index
  end
  
  def show
    @region = Region.find_by(eve_id: params[:region_id])
    @history = HistoryService.region_history(history_params)
    expires_in 1.days, public: true
    render json: @history, status: :ok
  rescue NotFoundError => e
    render json: {error: e.message}, status: :not_found
  end

  def history_params
    { region_id: @region.id, item: params[:id] }
  end
end
