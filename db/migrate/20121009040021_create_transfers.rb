class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.string :title

      t.timestamps
    end
  end
end
