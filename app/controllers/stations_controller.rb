class StationsController < ApplicationController
  def new
  end
  
  def create
    @region = Region.find(params[:region_id])
    @station = @region.stations.create(station_params)
    redirect_to region_path(@region)
  end

  def destroy
    region = Region.find(params[:region_id])
    station = region.stations.find(params[:id])
    station.destroy
    redirect_to region_path(region)
  end

  def station_params
    params.require(:station).permit(:name, :eveid)
  end
end
