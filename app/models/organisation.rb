# == Schema Information
#
# Table name: organisations
#
#  id                     :bigint           not null, primary key
#  code                   :string(12)
#  label                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  organisation_type_id   :integer
#  parent_organisation_id :integer
#
class Organisation < ApplicationRecord

  belongs_to :organisation_type
end
