class TripsController < ApplicationController
  def show
    @trip = Trip.find_by(id: params[:id])
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
      if params[:passenger_id]
        render :edit, status: :bad_request
      end

      if params[:driver_id]
        render :edit, status: :bad_request
      end
    end
  end

  def destroy
    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      head :not_found
    else
      passenger_id = trip.passenger_id
      driver_id = trip.driver_id
      url = request.original_url
      trip.destroy

      if url.include? "passengers"
        redirect_back fallback_location: passenger_path(passenger_id)
      elsif url.include? "drivers"
        redirect_back fallback_location: driver_path(driver_id)
      else
        redirect_to passenger_path(passenger_id)
      end
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :driver_id, :passenger_id, :cost, :rating)
  end
end
