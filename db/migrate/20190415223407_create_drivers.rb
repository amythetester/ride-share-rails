class CreateDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :string
      t.string :vin

      t.timestamps
    end
  end
end
