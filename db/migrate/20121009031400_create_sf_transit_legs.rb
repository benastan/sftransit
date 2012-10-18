class CreateSfTransitLegs < ActiveRecord::Migration
  def change
    create_table :sf_transit_legs do |t|
      t.string :abbr
      t.string :title
      t.integer :route_id

      t.timestamps
    end
  end
end
