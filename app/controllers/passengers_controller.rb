class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all.order(:name)
  end
end
