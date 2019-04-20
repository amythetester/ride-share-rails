class DriversController < ApplicationController
  def index
    @drivers = Driver.all.order(:name)
  end

  def show
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)

    is_successful = @driver.save

    if is_successful
      redirect_to driver_path(@driver.id)
    else
      render :new, status: :bad_request
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      head :not_found
    end
  end

  def update
    driver = Driver.find_by(id: params[:id])

    is_successful = driver.update(driver_params)

    if is_successful
      redirect_to driver_path(driver.id)
    else
      @driver = driver
      render :edit, status: :bad_request
    end
  end

  def destroy
    driver = Driver.find_by(id: params[:id])

    if driver.nil?
      head :not_found
    else
      trips = Trip.where(driver_id: driver.id)
      trips.each do |trip|
        trip.update(driver_id: 0)
      end
      driver.destroy
      redirect_to drivers_path
    end
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end
end
