class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :description
      t.belongs_to :user
      t.belongs_to :current_state

      t.timestamps
    end
  end
end
