# == Schema Information
#
# Table name: constituency_area_organisation_overlaps
#
#  id                                   :bigint           not null, primary key
#  constituency_area_population_overlap :float
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  constituency_area_id                 :integer
#  organisation_id                      :integer
#
class ConstituencyAreaOrganisationOverlap < ApplicationRecord
  belongs_to :constituency_area
  belongs_to :organisation
end
