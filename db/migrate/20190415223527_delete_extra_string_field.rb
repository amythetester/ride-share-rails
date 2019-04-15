class DeleteExtraStringField < ActiveRecord::Migration[5.2]
  def change
    remove_column :drivers, :string
  end
end
