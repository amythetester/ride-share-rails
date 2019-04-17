require "test_helper"

describe TripsController do
  describe "show" do
    it "should be OK to show an existing, valid trip" do
      test_p = Passenger.create(name: "test passenger", phone_num: "206-xxx-xxxx")
      test_d = Driver.create(name: "test driver", vin: "ABC3456")
      trip = Trip.create(
        date: "2019-03-05",
        rating: 4, cost: 1234,
        passenger_id: test_p.id,
        driver_id: test_d.id,
      )

      get trip_path(trip.id)

      must_respond_with :success
    end

    it "should give a 404 when giving an invalid trip id" do
      invalid_trip_id = 10000

      get trip_path(invalid_trip_id)

      must_respond_with :not_found
    end
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
