# == Schema Information
#
# Table name: organisation_typings
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  organisation_id      :integer
#  organisation_type_id :integer
#
class OrganisationTyping < ApplicationRecord
  belongs_to :organisation
  belongs_to :organisation_type
end
