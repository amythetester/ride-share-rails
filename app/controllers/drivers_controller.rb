class DriversController < ApplicationController
  def index
    @drivers = Driver.all.order(:name)
  end
end
