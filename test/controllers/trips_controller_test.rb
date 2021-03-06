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

      get passenger_trip_path(test_p.id, trip.id)
      get driver_trip_path(test_d.id, trip.id)

      must_respond_with :success
    end

    it "should give a 404 when giving an invalid trip id" do
      test_p = Passenger.create(name: "test passenger", phone_num: "206-xxx-xxxx")
      invalid_trip_id = 10000

      get passenger_trip_path(test_p.id, invalid_trip_id)

      must_respond_with :not_found
    end
  end

  describe "create" do
    it "will save a new trip and redirect if given valid inputs" do
      test_p_id = Passenger.create(name: "John Johnson", phone_num: "1234567890").id

      expect {
        post passenger_trips_path(test_p_id)
      }.must_change "Trip.count", 1

      new_trip = Trip.find_by(passenger_id: test_p_id)
      expect(new_trip).wont_be_nil
      expect(new_trip.date).must_equal Date.current
      expect(new_trip.passenger_id).must_equal test_p_id
      expect(new_trip.cost).must_be_kind_of Integer

      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "should get edit" do
      test_p = Passenger.create(name: "test passenger", phone_num: "206-xxx-xxxx")
      test_d = Driver.create(name: "test driver", vin: "ABC3456")
      trip = Trip.create(
        date: "2019-03-05",
        rating: 4,
        cost: 1234,
        passenger_id: test_p.id,
        driver_id: test_d.id,
      )
      get edit_passenger_trip_path(passenger_id: trip.passenger_id, id: trip.id)

      must_respond_with :success
    end

    it "should respond with 404 if the trip doesn't exist" do
      test_p = Passenger.create(name: "test passenger", phone_num: "206-xxx-xxxx")
      test_d = Driver.create(name: "test driver", vin: "ABC3456")
      get edit_passenger_trip_path(test_p.id, -1)

      must_respond_with :not_found

      get edit_driver_trip_path(test_d.id, -1)

      must_respond_with :not_found
    end
  end

  describe "update" do
    it "will update an existing trip" do
      starter_input = {
        date: Date.parse("2019-05-04"),
        driver_id: Driver.create(name: "test name", vin: "test vin").id,
        passenger_id: Passenger.create(name: "test name", phone_num: "test phone num").id,
        cost: 3456,
        rating: 4,
      }

      trip_to_update = Trip.create(starter_input)

      input_date = Date.parse("2019-05-07")
      input_cost = 4567
      test_input = {
        "trip": {
          date: input_date,
          cost: input_cost,
        },
      }

      expect {
        patch passenger_trip_path(trip_to_update.passenger_id, trip_to_update.id), params: test_input
      }.wont_change "Trip.count"

      must_respond_with :redirect
      trip_to_update.reload
      expect(trip_to_update.date).must_equal test_input[:trip][:date]
      expect(trip_to_update.cost).must_equal test_input[:trip][:cost]
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      starter_input = {
        date: Date.parse("2019-05-04"),
        driver_id: Driver.create(name: "test name", vin: "test vin").id,
        passenger_id: Passenger.create(name: "test name", phone_num: "test phone num").id,
        cost: 3456,
        rating: 4,
      }

      trip_to_update = Trip.create(starter_input)

      input_date = "invalid date"
      input_cost = "invalid cost"
      test_input = {
        "trip": {
          date: input_date,
          cost: input_cost,
        },
      }

      expect {
        patch passenger_trip_path(trip_to_update.passenger_id, trip_to_update.id), params: test_input
      }.wont_change "Trip.count"

      must_respond_with :bad_request
      trip_to_update.reload
      expect(trip_to_update.date).must_equal starter_input[:date]
      expect(trip_to_update.cost).must_equal starter_input[:cost]
    end
  end

  describe "destroy" do
    it "returns a 404 if the trip is not found" do
      test_p = Passenger.create(name: "test name", phone_num: "test phone num")

      invalid_id = "NOT A VALID ID"

      expect {
        # Act
        delete passenger_trip_path(passenger_id: test_p.id, id: invalid_id)
        # Assert
      }.wont_change "Trip.count"

      must_respond_with :not_found
    end

    it "can delete a trip" do
      new_trip = Trip.create(
        date: Date.parse("2019-03-07"),
        driver_id: Driver.create(name: "test name", vin: "test vin").id,
        passenger_id: Passenger.create(name: "test name", phone_num: "test phone num").id,
        cost: 3567,
        rating: 5,
      )

      expect {
        delete passenger_trip_path(new_trip.passenger_id, new_trip.id)

        # Assert
      }.must_change "Trip.count", -1

      must_respond_with :redirect
    end
  end
end
