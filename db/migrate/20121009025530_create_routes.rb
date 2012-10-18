class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :abbr
      t.string :agency
      t.string :title

      t.timestamps
    end
  end
end
