# == Schema Information
#
# Table name: elections
#
#  id                          :integer          not null, primary key
#  declaration_at              :datetime
#  invalid_vote_count          :integer
#  is_invalid_vote_count_known :boolean          default(TRUE)
#  is_notional                 :boolean          default(FALSE)
#  majority                    :integer
#  polling_on                  :date             not null
#  valid_vote_count            :integer
#  writ_issued_on              :date
#  constituency_group_id       :integer          not null
#  election_manager_id         :integer
#  election_state_id           :integer          default(4)
#  electorate_id               :integer
#  general_election_id         :integer
#  parliament_period_id        :integer          not null
#  result_summary_id           :integer
#
# Indexes
#
#  index_elections_on_constituency_group_id  (constituency_group_id)
#  index_elections_on_electorate_id          (electorate_id)
#  index_elections_on_general_election_id    (general_election_id)
#  index_elections_on_parliament_period_id   (parliament_period_id)
#  index_elections_on_result_summary_id      (result_summary_id)
#
# Foreign Keys
#
#  fk_constituency_group  (constituency_group_id => constituency_groups.id)
#  fk_electorate          (electorate_id => electorates.id)
#  fk_general_election    (general_election_id => general_elections.id)
#  fk_parliament_period   (parliament_period_id => parliament_periods.id)
#  fk_rails_...           (election_state_id => election_states.id)
#  fk_rails_...           (general_election_id => general_elections.id) ON DELETE => cascade
#  fk_result_summary      (result_summary_id => result_summaries.id)
#
class Election < ApplicationRecord
end
