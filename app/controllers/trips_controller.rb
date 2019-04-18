class TripsController < ApplicationController
  def index
    if params[:driver_id]
      @trips = Trip.where(driver: Driver.find_by(id: params[:driver_id]))
    elsif params[:passenger_id]
      @trips = Trip.where(passenger: Passenger.find_by(id: params[:passenger_id]))
    end
  end

  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    if @trip.nil?
      head :not_found
    end
  end

  def new
    @trip = Trip.new(date: Date.current)
  end

  def create
    offset = rand(Driver.count)
    rand_driver = Driver.offset(offset).first

    @trip = Trip.new(
      date: Date.current,
      driver_id: rand_driver.id,
      passenger_id: params[:passenger_id],
      cost: rand(100..30000),
      rating: nil,
    )

    is_successful = @trip.save

    if is_successful
      redirect_to trip_path(@trip.id)
    else
      render :new, status: :bad_request
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])

    is_successful = @trip.update(trip_params)
    if is_successful
      redirect_to passenger_path(params[:passenger_id])
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      head :not_found
    else
      trip.destroy
      redirect_back fallback_location: root_path
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :driver_id, :passenger_id, :cost, :rating)
  end
end
