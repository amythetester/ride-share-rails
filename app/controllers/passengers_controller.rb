class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all.order(:name)
  end

  def show
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)
    if @passenger.nil?
      head :not_found
    end
  end

  def new
    @passenger = Passenger.new
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
