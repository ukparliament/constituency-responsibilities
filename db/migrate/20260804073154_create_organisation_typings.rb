class CreateOrganisationTypings < ActiveRecord::Migration[8.1]
  def change
    create_table :organisation_typings do |t|
      t.integer :organisation_id
      t.integer :organisation_type_id
      t.timestamps
    end
  end
end
