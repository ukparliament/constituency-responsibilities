class AddConstituencyAreaOrganisationOverlapIdToConstituencyResponsibilities < ActiveRecord::Migration[8.1]
  def change
    add_column :constituency_responsibilities, :constituency_area_organisation_overlap_id, :integer
  end
end
