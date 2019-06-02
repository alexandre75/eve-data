class RegionsController < ApplicationController
  http_basic_authenticate_with name: "alex", password: "password"
  
  def index
    @regions = Region.all
  end

  def show
    @region = Region.find(params[:id])
  end
  
  def new
    @region = Region.new
  end

  def edit
    @region = Region.find(params[:id])
  end
  
  def create
    @region = Region.new(region_params)

    if @region.save
      redirect_to @region
    else
      render 'new'
    end
  end

  def update
    @region = Region.find(params[:id])

    if @region.update(region_params)
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    region = Region.find(params[:id])
    region.destroy
    @region = nil
    redirect_to regions_path
  end
  
  def region_params
    params.require(:region).permit(:name, :eve_id)
  end
end
