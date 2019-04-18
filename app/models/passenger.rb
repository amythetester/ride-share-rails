class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :phone_num, presence: true, uniqueness: true

  def total_spent
    sum = 0
    trips = Trip.where(id: self.id)
    trips.each do |trip|
      sum += trip.cost
    end
    return sum
  end
end
