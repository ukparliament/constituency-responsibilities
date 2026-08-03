# == Schema Information
#
# Table name: constituency_areas
#
#  id                               :integer          not null, primary key
#  geographic_code                  :string(255)      not null
#  is_geographic_code_issued_by_ons :boolean          default(TRUE)
#  name                             :string(255)      not null
#  boundary_set_id                  :integer
#  constituency_area_type_id        :integer          not null
#  country_id                       :integer          not null
#  english_region_id                :integer
#  mnis_id                          :integer
#
# Indexes
#
#  index_constituency_areas_on_boundary_set_id            (boundary_set_id)
#  index_constituency_areas_on_constituency_area_type_id  (constituency_area_type_id)
#  index_constituency_areas_on_country_id                 (country_id)
#  index_constituency_areas_on_english_region_id          (english_region_id)
#
# Foreign Keys
#
#  fk_boundary_set            (boundary_set_id => boundary_sets.id)
#  fk_constituency_area_type  (constituency_area_type_id => constituency_area_types.id)
#  fk_country                 (country_id => countries.id)
#  fk_english_region          (english_region_id => english_regions.id)
#
class ConstituencyArea < ApplicationRecord
end
