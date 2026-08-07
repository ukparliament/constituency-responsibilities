class CreateResponsibilities < ActiveRecord::Migration[8.1]
  def change
    create_table :responsibilities do |t|
      t.string :label, :limit => 255
      t.timestamps
    end
  end
end
