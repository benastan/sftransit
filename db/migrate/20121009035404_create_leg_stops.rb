class CreateLegStops < ActiveRecord::Migration
  def change
    create_table :leg_stops do |t|
      t.integer :stop_id
      t.integer :leg_id

      t.timestamps
    end
  end
end
