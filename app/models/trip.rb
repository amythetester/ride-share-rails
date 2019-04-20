class Trip < ApplicationRecord
  belongs_to :passenger
  belongs_to :driver

  validates :date, presence: true
  validates :cost, presence: true
end
