# == Schema Information
#
# Table name: responsibilities
#
#  id         :bigint           not null, primary key
#  label      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Responsibility < ApplicationRecord
end
