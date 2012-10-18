class CreateJunctions < ActiveRecord::Migration
  def change
    create_table :junctions do |t|
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.text :name
      t.string :address

      t.timestamps
    end
  end
end
