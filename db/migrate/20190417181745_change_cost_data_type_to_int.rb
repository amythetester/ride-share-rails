class ChangeCostDataTypeToInt < ActiveRecord::Migration[5.2]
  def change
    change_column :trips, :cost, :integer
  end
end
