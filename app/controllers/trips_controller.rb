class TripsController < ApplicationController
  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    if @trip.nil?
      head :not_found
    end
  end

  def create
    chosen_driver = Driver.where(available: true).sample(1)
    @trip = Trip.new(
      date: Date.current,
      driver_id: chosen_driver.first.id,
      passenger_id: params[:passenger_id],
      cost: rand(100..30000),
      rating: nil,
    )

    is_successful = @trip.save

    if is_successful
      chosen_driver.first.available = false
      chosen_driver.first.save
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
      redirect_to trip_path(params[:id])
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
