require "test_helper"
require "pry"

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
    it "will save a new passenger and redirect if given valid inputs" do
      test_input = {
        "passenger": {
          name: "Goofy",
          phone_num: "206-123-4567",
        },
      }

      expect {
        post passengers_path, params: test_input
      }.must_change "Passenger.count", 1

      new_passenger = Passenger.find_by(name: "Goofy")
      expect(new_passenger).wont_be_nil
      expect(new_passenger.name).must_equal "Goofy"
      expect(new_passenger.phone_num).must_equal "206-123-4567"

      must_respond_with :redirect
    end

    it "will return a 400 with an invalid entry" do
      test_input = {
        "passenger": {
          name: "Donald",
          phone_num: "",
        },
      }

      expect {
        post passengers_path, params: test_input
      }.wont_change "Passenger.count"

      must_respond_with :bad_request
    end
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    it "will update an existing passenger" do
      starter_input = {
        name: "Minnie",
        phone_num: "206-456-7890",
      }

      passenger_to_update = Passenger.create(starter_input)

      test_input = {
        "passenger": {
          name: "Minnie Mouse",
          phone_num: "206-456-7890",
        },
      }

      expect {
        patch passenger_path(passenger_to_update.id), params: test_input
      }.wont_change "Passenger.count"

      must_respond_with :redirect

      passenger_to_update.reload
      expect(passenger_to_update.name).must_equal "Minnie Mouse"
      expect(passenger_to_update.phone_num).must_equal "206-456-7890"
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      starter_input = {
        name: "Daisy",
        phone_num: "425-737-6510",
      }

      passenger_to_update = Passenger.create(starter_input)

      test_input = {
        "passenger": {
          name: "",
          phone_num: "425-737-6510",
        },
      }

      expect {
        patch passenger_path(passenger_to_update.id), params: test_input
      }.wont_change "Passenger.count"

      must_respond_with :bad_request
      passenger_to_update.reload
      expect(passenger_to_update.name).must_equal starter_input[:name]
      expect(passenger_to_update.phone_num).must_equal starter_input[:phone_num]
    end

    # edge case: it should render a 404 if the book was not found
  end

  describe "destroy" do
    it "returns a 404 if the passenger is not found" do
      invalid_id = "NOT A VALID ID"
      expect {
        delete passenger_path(invalid_id)
      }.wont_change "Passenger.count"

      must_respond_with :not_found
    end

    it "can delete a passenger" do
      new_passenger = Passenger.create(name: "Cinderella", phone_num: "206-345-8910")

      expect {
        delete passenger_path(new_passenger.id)
      }.must_change "Passenger.count", -1

      must_respond_with :redirect
      must_redirect_to passengers_path
    end
  end
end
