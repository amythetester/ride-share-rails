class DeleteColumnAvailableFromDriverTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :drivers, :available
  end
end
