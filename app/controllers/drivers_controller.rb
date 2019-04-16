class DriversController < ApplicationController
  def index
    @drivers = Driver.all.order(:name)
  end

  def show
    driver_id = params[:id]
    @driver = Driver.find_by(id: driver_id)

    if @driver.nil?
      head :not_found
    end
  end

  def new
    @driver = Driver.new(name: "Default Name")
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin)
  end
end
