class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true, uniqueness: true

  def average_rating
    sum = 0
    trips = Trip.where(driver_id: self.id)
    trips.each do |trip|
      if trip.rating.nil?
        next
      end
      sum += trip.rating
    end
    if sum == 0
      return "No rating recorded"
    else
      avg_rating = sum / trips.count
      return avg_rating
    end
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
