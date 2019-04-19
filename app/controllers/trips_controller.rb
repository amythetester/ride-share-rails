class TripsController < ApplicationController
  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    if @trip.nil?
      head :not_found
    end
  end

  def create
    chosen_drivers = Driver.where(available: true).sample(1)
    @trip = Trip.new(
      date: Date.current,
      driver_id: chosen_drivers.first.id,
      passenger_id: params[:passenger_id],
      cost: rand(100..30000),
      rating: nil,
    )

    is_successful = @trip.save

    if is_successful
      chosen_drivers.first.available = false
      chosen_drivers.first.save
      if params[:passenger_id]
        redirect_to passenger_trip_path(params[:passenger_id], @trip.id)
      end

      if params[:driver_id]
        redirect_to driver_trip_path(params[:driver_id], @trip.id)
      end
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
      if params[:passenger_id]
        redirect_to passenger_trip_path(params[:passenger_id])
        return
      end

      if params[:driver_id]
        redirect_to driver_trip_path(params[:driver_id])
        return
      end
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
