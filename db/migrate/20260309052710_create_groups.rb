class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :group_type, null: false

      t.timestamps
    end

    add_index :groups, :group_type
  end
end
