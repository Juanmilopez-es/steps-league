class CreateUserGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :user_groups do |t|
      t.string :device_id, null: false
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_groups, :device_id
    add_index :user_groups, [:device_id, :group_id], unique: true
  end
end
