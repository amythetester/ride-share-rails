class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true, uniqueness: true

  def average_rating
    sum = 0
    trips = Trip.where(driver_id: self.id)
    trips.each do |trip|
      sum += trip.rating
    end
    avg_rating = sum / trips.count
    return avg_rating
  end
end
