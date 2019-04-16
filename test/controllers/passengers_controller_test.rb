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
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
