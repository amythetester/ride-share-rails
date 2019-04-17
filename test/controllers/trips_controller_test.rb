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

  describe "new" do
    it "should get new" do
      get new_trip_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "will save a new trip and redirect if given valid inputs" do
      # Arrange
      input_date = Date.parse("2019-01-02")
      input_cost = 1000
      input_rating = 4
      test_input = {
        "trip": {
          date: input_date,
          driver_id: Driver.create(name: "Susan Hill", vin: "0987654321").id,
          passenger_id: Passenger.create(name: "John Johnson", phone_num: "1234567890").id,
          cost: input_cost,
          rating: input_rating,
        },
      }

      # Act
      expect {
        post trips_path, params: test_input
      }.must_change "Trip.count", 1

      # Assert
      new_trip = Trip.find_by(date: input_date)
      expect(new_trip).wont_be_nil
      expect(new_trip.date).must_equal input_date
      expect(new_trip.cost).must_equal input_cost
      expect(new_trip.rating).must_equal input_rating

      must_respond_with :redirect
    end

    it "will return a 400 with an invalid trip" do
      # Arrange
      input_date = ""
      input_cost = 1000
      input_rating = 4
      test_input = {
        "trip": {
          date: input_date,
          driver_id: Driver.create(name: "Susan Hill", vin: "0987654321").id,
          passenger_id: Passenger.create(name: "John Johnson", phone_num: "1234567890").id,
          cost: input_cost,
          rating: input_rating,
        },
      }

      # Act
      expect {
        post trips_path, params: test_input
      }.wont_change "Trip.count"

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "should get edit" do
      get edit_trip_path(Trip.first.id)

      must_respond_with :success
    end

    it "should respond with 404 if the trip doesn't exist" do
      get edit_trip_path(-1)

      must_respond_with :not_found
    end
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
