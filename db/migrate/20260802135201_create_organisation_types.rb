class CreateOrganisationTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :organisation_types do |t|
      t.string :label, :limit => 255
      t.timestamps
    end
  end
end
