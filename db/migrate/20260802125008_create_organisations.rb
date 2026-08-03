class CreateOrganisations < ActiveRecord::Migration[8.1]
  def change
    create_table :organisations do |t|
      t.string :label, :limit => 255
      t.string :code, :limit => 12
      t.integer :parent_organisation_id
      t.integer :organisation_type_id
      t.timestamps
    end
  end
end
