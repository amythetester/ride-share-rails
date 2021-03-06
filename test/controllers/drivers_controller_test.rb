require "test_helper"

describe DriversController do
  describe "index" do
    it "can get index" do
      get drivers_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "should be OK to show an existing, valid driver" do
      driver = Driver.create(name: "Amy Wyatt", vin: "1234567890", available: true)
      valid_driver_id = driver.id

      get driver_path(valid_driver_id)

      must_respond_with :success
    end

    it "should give a 404 instead of showing a non-existant, invalid driver" do
      invalid_driver_id = 999

      get driver_path(invalid_driver_id)

      must_respond_with :not_found
    end
  end

  describe "new" do
    it "should get new" do
      get new_driver_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "will save a new driver and redirect if given valid inputs" do
      # Arrange
      input_name = "John Smith"
      input_vin = "7584938476"
      input_available = true
      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
          available: input_available,
        },
      }

      # Act
      expect {
        post drivers_path, params: test_input
      }.must_change "Driver.count", 1

      # Assert
      new_driver = Driver.find_by(name: input_name)
      expect(new_driver).wont_be_nil
      expect(new_driver.name).must_equal input_name
      expect(new_driver.vin).must_equal input_vin
      expect(new_driver.available).must_equal true

      must_respond_with :redirect
    end

    it "will return a 400 with an invalid driver" do
      # Arrange
      input_name = ""
      input_vin = "0987654321"
      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
          available: true,
        },
      }

      # Act
      expect {
        post drivers_path, params: test_input
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "should get edit" do
      get edit_driver_path(Driver.first.id)

      must_respond_with :success
    end

    it "should respond with 404 if the driver doesn't exist" do
      get edit_driver_path(-1)

      must_respond_with :not_found
    end
  end

  describe "update" do
    it "will update an existing driver" do
      # Arrange
      starter_input = {
        name: "Sue Zan",
        vin: "0987654321",
      }

      driver_to_update = Driver.create(starter_input)

      input_name = "Sue Johnson"
      input_vin = "0987654321"
      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
          available: true,
        },
      }

      # Act
      expect {
        patch driver_path(driver_to_update.id), params: test_input
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :redirect
      driver_to_update.reload
      expect(driver_to_update.name).must_equal test_input[:driver][:name]
      expect(driver_to_update.vin).must_equal test_input[:driver][:vin]
      expect(driver_to_update.available).must_equal true
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      # Arrange
      starter_input = {
        name: "Sue Zan",
        vin: "0987654321",
        available: true,
      }

      driver_to_update = Driver.create(starter_input)

      input_name = ""
      input_vin = "0987654321"
      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
        },
      }

      # Act
      expect {
        patch driver_path(driver_to_update.id), params: test_input
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :bad_request
      driver_to_update.reload
      expect(driver_to_update.name).must_equal starter_input[:name]
      expect(driver_to_update.vin).must_equal starter_input[:vin]
      expect(driver_to_update.available).must_equal true
    end
  end

  describe "destroy" do
    it "returns a 404 if the book is not found" do
      # Arrange
      invalid_id = "NOT A VALID ID"

      expect {
        # Act
        delete driver_path(invalid_id)
        # Assert
      }.wont_change "Driver.count"

      must_respond_with :not_found
    end

    it "can delete a driver" do
      new_driver = Driver.create(name: "David Tuo", vin: "7684938476")

      expect {
        delete driver_path(new_driver.id)
      }.must_change "Driver.count", -1

      must_respond_with :redirect
      must_redirect_to drivers_path
    end
  end
end
