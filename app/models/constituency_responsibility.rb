# == Schema Information
#
# Table name: constituency_responsibilities
#
#  id                                        :bigint           not null, primary key
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  constituency_area_id                      :integer
#  constituency_area_organisation_overlap_id :integer
#  organisation_id                           :integer
#  responsibility_id                         :integer
#
class ConstituencyResponsibility < ApplicationRecord
  belongs_to :constituency_area
  belongs_to :organisation
  belongs_to :responsibility
  belongs_to :constituency_area_organisation_overlap
end
