class CreateLegJunctions < ActiveRecord::Migration
  def change
    create_table :leg_junctions do |t|
      t.integer :junction_id
      t.integer :leg_id
      t.integer :weight

      t.timestamps
    end
  end
end
