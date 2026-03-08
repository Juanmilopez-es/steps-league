class CreateSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :steps do |t|
      t.string :device_id
      t.integer :count
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
