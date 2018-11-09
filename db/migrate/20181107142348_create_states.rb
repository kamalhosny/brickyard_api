class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :name
      t.integer :order, unique: true

      t.timestamps
    end
  end
end
