class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.string :address
      t.string :title
      t.integer :transfer_id

      t.timestamps
    end
  end
end
