class CreateConstituencyAreaOrganisationOverlaps < ActiveRecord::Migration[8.1]
  def change
    create_table :constituency_area_organisation_overlaps do |t|
      t.integer :constituency_area_id
      t.integer :organisation_id
      t.float :constituency_area_population_overlap
      t.timestamps
    end
  end
end
