class AddUniqueIndexToSteps < ActiveRecord::Migration[8.1]
  def up
    # First, clean up duplicates keeping only the record with max count per device_id + date
    execute <<-SQL
      DELETE FROM steps
      WHERE id NOT IN (
        SELECT DISTINCT ON (device_id, DATE(recorded_at)) id
        FROM steps
        ORDER BY device_id, DATE(recorded_at), count DESC, id DESC
      )
    SQL

    # Normalize recorded_at to start of day for remaining records
    execute <<-SQL
      UPDATE steps
      SET recorded_at = DATE(recorded_at)
    SQL

    # Then add the unique index
    add_index :steps, [:device_id, :recorded_at], unique: true, name: 'index_steps_on_device_id_and_date'
  end

  def down
    remove_index :steps, name: 'index_steps_on_device_id_and_date'
  end
end
