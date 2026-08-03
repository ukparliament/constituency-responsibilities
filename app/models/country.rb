# == Schema Information
#
# Table name: countries
#
#  id                :integer          not null, primary key
#  geographic_code   :string(255)
#  name              :string(255)      not null
#  ons_linked        :boolean          default(FALSE)
#  parent_country_id :integer
#
# Foreign Keys
#
#  fk_parent_country  (parent_country_id => countries.id)
#
class Country < ApplicationRecord
end
