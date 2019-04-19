class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true, uniqueness: true
  validates :available, presence: true

  def average_rating
    sum_ratings = 0
    num_trips = 0
    trips = Trip.where(driver_id: self.id)
    trips.each do |trip|
      if trip.rating.nil?
        next
      end
      sum_ratings += trip.rating
      num_trips += 1
    end

    return sum_ratings == 0 ? "No rating recorded" : sum_ratings / num_trips
  end

  def total_earnings
    sum = 0
    trips = Trip.where(driver_id: self.id)
    trips.each do |trip|
      sum += (trip.cost - 165) * 0.8
    end
    return sum
  end
end
