class CreateSfTransitLegStops < ActiveRecord::Migration
  def change
    create_table :sf_transit_leg_stops do |t|
      t.integer :stop_id
      t.integer :leg_id

      t.timestamps
    end
  end
end
