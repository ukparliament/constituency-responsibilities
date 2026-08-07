class CreateConstituencyResponsibilities < ActiveRecord::Migration[8.1]
  def change
    create_table :constituency_responsibilities do |t|
      t.integer :organisation_id
      t.integer :constituency_area_id
      t.integer :responsibility_id
      t.timestamps
    end
  end
end
