require "test_helper"

describe PassengersController do
  describe "index" do
    it "lists all existing passengers" do
      get passengers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should be OK to show an existing, valid passenger" do
      passenger = Passenger.create(name: "test passenger", phone_num: "206-xxx-xxxx")

      get passenger_path(passenger.id)

      must_respond_with :success
    end

    it "should give a 404 when giving an invalid passenger id" do
      invalid_passenger_id = 10000

      get passenger_path(invalid_passenger_id)

      must_respond_with :not_found
    end
  end

  describe "new" do
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
