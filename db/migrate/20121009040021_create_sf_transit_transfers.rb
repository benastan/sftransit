class CreateSfTransitTransfers < ActiveRecord::Migration
  def change
    create_table :sf_transit_transfers do |t|
      t.string :title

      t.timestamps
    end
  end
end
