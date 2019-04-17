class TripsController < ApplicationController
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
    @trip = Trip.new(trip_params)

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
    trip = Trip.find_by(id: params[:id])

    is_successful = trip.update(trip_params)

    if is_successful
      redirect_to trip_path(trip.id)
    else
      @trip = trip
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
