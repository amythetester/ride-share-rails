require "test_helper"

describe DriversController do
  describe "index" do
    it "can get index" do
      # Act
      get drivers_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "should be OK to show an existing, valid driver" do
      # Arrange
      driver = Driver.create(name: "Amy Wyatt", vin: "1234567890")
      valid_driver_id = driver.id

      # Act
      get driver_path(valid_driver_id)

      # Assert
      must_respond_with :success
    end

    it "should give a 404 instead of showing a non-existant, invalid driver" do
      # Arrange
      invalid_driver_id = 999

      # Act
      get driver_path(invalid_driver_id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    # Your tests go here
  end

  describe "create" do
    it "will save a new driver and redirect if given valid inputs" do
      # Arrange
      input_name = "John Smith"
      input_vin = "7584938476"
      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
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

      must_respond_with :redirect
    end

    it "will return a 400 with an invalid book" do
      # Arrange
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
        post drivers_path, params: test_input
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "edit" do
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
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      # Arrange
      starter_input = {
        name: "Sue Zan",
        vin: "0987654321",
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
    end

    # edge case: it should render a 404 if the book was not found
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
