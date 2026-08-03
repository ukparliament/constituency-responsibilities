# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_03_102827) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"

  create_table "boundary_set_legislation_items", id: :serial, force: :cascade do |t|
    t.integer "boundary_set_id", null: false
    t.integer "legislation_item_id", null: false
    t.index ["boundary_set_id"], name: "index_boundary_set_legislation_items_on_boundary_set_id"
    t.index ["legislation_item_id"], name: "index_boundary_set_legislation_items_on_legislation_item_id"
  end

  create_table "boundary_sets", id: :serial, force: :cascade do |t|
    t.integer "country_id", null: false
    t.string "description", limit: 255
    t.date "end_on"
    t.integer "parent_boundary_set_id"
    t.date "start_on"
    t.index ["country_id"], name: "index_boundary_sets_on_country_id"
  end

  create_table "candidacies", id: :serial, force: :cascade do |t|
    t.string "candidate_family_name", limit: 255
    t.integer "candidate_gender_id"
    t.string "candidate_given_name", limit: 255
    t.boolean "candidate_is_former_mp", default: false
    t.boolean "candidate_is_sitting_mp", default: false
    t.integer "democracy_club_person_identifier"
    t.integer "election_id", null: false
    t.integer "election_manager_id"
    t.boolean "is_notional", default: false
    t.boolean "is_notional_political_party_aggregate", default: false
    t.boolean "is_standing_as_commons_speaker", default: false
    t.boolean "is_standing_as_independent", default: false
    t.boolean "is_winning_candidacy", default: false
    t.integer "member_id"
    t.integer "result_position"
    t.float "vote_change", limit: 24
    t.integer "vote_count"
    t.float "vote_share", limit: 24
    t.index ["candidate_gender_id"], name: "index_candidacies_on_candidate_gender_id"
    t.index ["election_id"], name: "index_candidacies_on_election_id"
    t.index ["member_id"], name: "index_candidacies_on_member_id"
  end

  create_table "certifications", id: :serial, force: :cascade do |t|
    t.integer "adjunct_to_certification_id"
    t.integer "candidacy_id", null: false
    t.integer "political_party_id", null: false
    t.index ["candidacy_id"], name: "index_certifications_on_candidacy_id"
    t.index ["political_party_id"], name: "index_certifications_on_political_party_id"
  end

  create_table "commons_library_dashboard_countries", id: :serial, force: :cascade do |t|
    t.integer "commons_library_dashboard_id", null: false
    t.integer "country_id", null: false
  end

  create_table "commons_library_dashboards", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.string "url", limit: 255, null: false
  end

  create_table "constituency_area_organisation_overlaps", force: :cascade do |t|
    t.integer "constituency_area_id"
    t.float "constituency_area_population_overlap"
    t.datetime "created_at", null: false
    t.integer "organisation_id"
    t.datetime "updated_at", null: false
  end

  create_table "constituency_area_overlaps", id: :serial, force: :cascade do |t|
    t.boolean "formed_from_whole_of", default: false
    t.boolean "forms_whole_of", default: false
    t.integer "from_constituency_area_id", null: false
    t.float "from_constituency_geographical", limit: 24, null: false
    t.float "from_constituency_population", limit: 24, null: false
    t.float "from_constituency_residential", limit: 24, null: false
    t.integer "to_constituency_area_id", null: false
    t.float "to_constituency_geographical", limit: 24, null: false
    t.float "to_constituency_population", limit: 24, null: false
    t.float "to_constituency_residential", limit: 24, null: false
  end

  create_table "constituency_area_types", id: :serial, force: :cascade do |t|
    t.string "area_type", limit: 20, null: false
  end

  create_table "constituency_areas", id: :serial, force: :cascade do |t|
    t.integer "boundary_set_id"
    t.integer "constituency_area_type_id", null: false
    t.integer "country_id", null: false
    t.integer "english_region_id"
    t.string "geographic_code", limit: 255, null: false
    t.boolean "is_geographic_code_issued_by_ons", default: true
    t.integer "mnis_id"
    t.string "name", limit: 255, null: false
    t.index ["boundary_set_id"], name: "index_constituency_areas_on_boundary_set_id"
    t.index ["constituency_area_type_id"], name: "index_constituency_areas_on_constituency_area_type_id"
    t.index ["country_id"], name: "index_constituency_areas_on_country_id"
    t.index ["english_region_id"], name: "index_constituency_areas_on_english_region_id"
  end

  create_table "constituency_group_set_legislation_items", id: :serial, force: :cascade do |t|
    t.integer "constituency_group_set_id", null: false
    t.integer "legislation_item_id", null: false
  end

  create_table "constituency_group_sets", id: :serial, force: :cascade do |t|
    t.integer "country_id", null: false
    t.string "description", limit: 255
    t.date "end_on"
    t.integer "parent_constituency_group_set_id"
    t.date "start_on"
    t.index ["country_id"], name: "index_constituency_group_sets_on_country_id"
  end

  create_table "constituency_groups", id: :serial, force: :cascade do |t|
    t.integer "constituency_area_id"
    t.integer "constituency_group_set_id"
    t.string "name", limit: 255, null: false
    t.index ["constituency_area_id"], name: "index_constituency_groups_on_constituency_area_id"
    t.index ["constituency_group_set_id"], name: "index_constituency_groups_on_constituency_group_set_id"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "geographic_code", limit: 255
    t.string "name", limit: 255, null: false
    t.boolean "ons_linked", default: false
    t.integer "parent_country_id"
  end

  create_table "election_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label"
    t.integer "state"
    t.datetime "updated_at", null: false
  end

  create_table "elections", id: :serial, force: :cascade do |t|
    t.integer "constituency_group_id", null: false
    t.datetime "declaration_at", precision: nil
    t.integer "election_manager_id"
    t.integer "election_state_id", default: 4
    t.integer "electorate_id"
    t.integer "general_election_id"
    t.integer "invalid_vote_count"
    t.boolean "is_invalid_vote_count_known", default: true
    t.boolean "is_notional", default: false
    t.integer "majority"
    t.integer "parliament_period_id", null: false
    t.date "polling_on", null: false
    t.integer "result_summary_id"
    t.integer "valid_vote_count"
    t.date "writ_issued_on"
    t.index ["constituency_group_id"], name: "index_elections_on_constituency_group_id"
    t.index ["electorate_id"], name: "index_elections_on_electorate_id"
    t.index ["general_election_id"], name: "index_elections_on_general_election_id"
    t.index ["parliament_period_id"], name: "index_elections_on_parliament_period_id"
    t.index ["result_summary_id"], name: "index_elections_on_result_summary_id"
  end

  create_table "electorates", id: :serial, force: :cascade do |t|
    t.integer "constituency_group_id", null: false
    t.integer "population_count", null: false
    t.index ["constituency_group_id"], name: "index_electorates_on_constituency_group_id"
  end

  create_table "enablings", id: :serial, force: :cascade do |t|
    t.integer "enabled_legislation_id", null: false
    t.integer "enabling_legislation_id", null: false
  end

  create_table "english_regions", id: :serial, force: :cascade do |t|
    t.integer "country_id", null: false
    t.string "geographic_code", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.index ["country_id"], name: "index_english_regions_on_country_id"
  end

  create_table "genders", id: :serial, force: :cascade do |t|
    t.string "gender", limit: 20, null: false
  end

  create_table "general_election_in_boundary_sets", id: :serial, force: :cascade do |t|
    t.integer "boundary_set_id", null: false
    t.integer "general_election_id", null: false
    t.integer "ordinality", null: false
    t.index ["boundary_set_id"], name: "index_general_election_in_boundary_sets_on_boundary_set_id"
  end

  create_table "general_election_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label"
    t.integer "state"
    t.datetime "updated_at", null: false
  end

  create_table "general_elections", id: :serial, force: :cascade do |t|
    t.string "commons_library_briefing_url", limit: 255
    t.integer "general_election_state_id", default: 4
    t.boolean "is_notional", default: false
    t.integer "parliament_period_id", null: false
    t.date "polling_on", null: false
    t.index ["parliament_period_id"], name: "index_general_elections_on_parliament_period_id"
  end

  create_table "legislation_items", id: :serial, force: :cascade do |t|
    t.integer "legislation_type_id", null: false
    t.date "made_on"
    t.date "royal_assent_on"
    t.date "statute_book_on", null: false
    t.string "title", limit: 255, null: false
    t.string "uri", limit: 255
    t.string "url_key", limit: 20, null: false
    t.index ["legislation_type_id"], name: "index_legislation_items_on_legislation_type_id"
  end

  create_table "legislation_types", id: :serial, force: :cascade do |t|
    t.string "abbreviation", limit: 10, null: false
    t.string "label", limit: 255, null: false
  end

  create_table "maiden_speeches", id: :serial, force: :cascade do |t|
    t.integer "constituency_group_id", null: false
    t.string "hansard_reference", limit: 255, null: false
    t.string "hansard_url", limit: 255, null: false
    t.date "made_on", null: false
    t.integer "member_id", null: false
    t.integer "parliament_period_id", null: false
    t.integer "session_number", null: false
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.string "family_name", limit: 255, null: false
    t.string "given_name", limit: 255, null: false
    t.integer "mnis_id", null: false
  end

  create_table "organisation_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label", limit: 255
    t.datetime "updated_at", null: false
  end

  create_table "organisations", force: :cascade do |t|
    t.string "code", limit: 12
    t.datetime "created_at", null: false
    t.string "label", limit: 255
    t.integer "organisation_type_id"
    t.integer "parent_organisation_id"
    t.datetime "updated_at", null: false
  end

  create_table "parliament_periods", id: :serial, force: :cascade do |t|
    t.string "commons_library_briefing_by_election_briefing_url", limit: 255
    t.date "dissolved_on"
    t.string "london_gazette", limit: 30
    t.integer "number", null: false
    t.date "state_opening_on"
    t.date "summoned_on", null: false
    t.string "wikidata_id", limit: 20
  end

  create_table "political_parties", id: :serial, force: :cascade do |t|
    t.string "abbreviation", limit: 255, null: false
    t.string "disclaimer", limit: 500
    t.boolean "has_been_parliamentary_party", default: false
    t.integer "mnis_id"
    t.string "name", limit: 255, null: false
  end

  create_table "political_party_registrations", id: :serial, force: :cascade do |t|
    t.integer "country_id", null: false
    t.string "electoral_commission_id", limit: 20, null: false
    t.date "end_on"
    t.integer "political_party_id", null: false
    t.date "political_party_name_last_updated_on"
    t.date "start_on", null: false
  end

  create_table "responsibility_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label", limit: 255
    t.datetime "updated_at", null: false
  end

  create_table "result_summaries", id: :serial, force: :cascade do |t|
    t.integer "from_political_party_id"
    t.boolean "is_from_commons_speaker", default: false
    t.boolean "is_from_independent", default: false
    t.boolean "is_to_commons_speaker", default: false
    t.boolean "is_to_independent", default: false
    t.string "short_summary", limit: 50, null: false
    t.string "summary", limit: 255
    t.integer "to_political_party_id"
  end

  create_table "task_records", id: false, force: :cascade do |t|
    t.string "version", null: false
  end

  add_foreign_key "boundary_set_legislation_items", "boundary_sets", name: "fk_boundary_set"
  add_foreign_key "boundary_set_legislation_items", "legislation_items", name: "fk_legislation_item"
  add_foreign_key "boundary_sets", "boundary_sets", column: "parent_boundary_set_id", name: "fk_parent_boundary_set"
  add_foreign_key "boundary_sets", "countries", name: "fk_country"
  add_foreign_key "candidacies", "elections", name: "fk_election"
  add_foreign_key "candidacies", "elections", on_delete: :cascade
  add_foreign_key "candidacies", "genders", column: "candidate_gender_id", name: "fk_candidate_gender"
  add_foreign_key "candidacies", "members", name: "fk_member"
  add_foreign_key "certifications", "candidacies", name: "fk_candidacy"
  add_foreign_key "certifications", "candidacies", on_delete: :cascade
  add_foreign_key "certifications", "certifications", column: "adjunct_to_certification_id", name: "fk_adjunct_to_certification"
  add_foreign_key "certifications", "political_parties", name: "fk_political_party"
  add_foreign_key "commons_library_dashboard_countries", "commons_library_dashboards", name: "fk_commons_library_dashboard"
  add_foreign_key "commons_library_dashboard_countries", "countries", name: "fk_country"
  add_foreign_key "constituency_area_overlaps", "constituency_areas", column: "from_constituency_area_id", name: "fk_from_constituency_area"
  add_foreign_key "constituency_area_overlaps", "constituency_areas", column: "to_constituency_area_id", name: "fk_to_constituency_area"
  add_foreign_key "constituency_areas", "boundary_sets", name: "fk_boundary_set"
  add_foreign_key "constituency_areas", "constituency_area_types", name: "fk_constituency_area_type"
  add_foreign_key "constituency_areas", "countries", name: "fk_country"
  add_foreign_key "constituency_areas", "english_regions", name: "fk_english_region"
  add_foreign_key "constituency_group_set_legislation_items", "constituency_group_sets", name: "fk_constituency_group_set"
  add_foreign_key "constituency_group_set_legislation_items", "legislation_items", name: "fk_legislation_item"
  add_foreign_key "constituency_group_sets", "constituency_group_sets", column: "parent_constituency_group_set_id", name: "fk_parent_constituency_group_set"
  add_foreign_key "constituency_group_sets", "countries", name: "fk_country"
  add_foreign_key "constituency_groups", "constituency_areas", name: "fk_constituency_area"
  add_foreign_key "constituency_groups", "constituency_group_sets", name: "fk_constituency_group_set"
  add_foreign_key "countries", "countries", column: "parent_country_id", name: "fk_parent_country"
  add_foreign_key "elections", "constituency_groups", name: "fk_constituency_group"
  add_foreign_key "elections", "election_states"
  add_foreign_key "elections", "electorates", name: "fk_electorate"
  add_foreign_key "elections", "general_elections", name: "fk_general_election"
  add_foreign_key "elections", "general_elections", on_delete: :cascade
  add_foreign_key "elections", "parliament_periods", name: "fk_parliament_period"
  add_foreign_key "elections", "result_summaries", name: "fk_result_summary"
  add_foreign_key "electorates", "constituency_groups", name: "fk_constituency_group"
  add_foreign_key "enablings", "legislation_items", column: "enabled_legislation_id", name: "fk_enabled_legislation"
  add_foreign_key "enablings", "legislation_items", column: "enabling_legislation_id", name: "fk_enabling_legislation"
  add_foreign_key "english_regions", "countries", name: "fk_country"
  add_foreign_key "general_election_in_boundary_sets", "boundary_sets", name: "fk_parent_boundary_set"
  add_foreign_key "general_election_in_boundary_sets", "general_elections", name: "fk_parent_general_election"
  add_foreign_key "general_election_in_boundary_sets", "general_elections", on_delete: :cascade
  add_foreign_key "general_elections", "general_election_states"
  add_foreign_key "general_elections", "parliament_periods", name: "fk_parliament_period"
  add_foreign_key "legislation_items", "legislation_types", name: "fk_legislation_type"
  add_foreign_key "maiden_speeches", "constituency_groups", name: "fk_constituency_group"
  add_foreign_key "maiden_speeches", "members", name: "fk_member"
  add_foreign_key "maiden_speeches", "parliament_periods", name: "fk_parliament_period"
  add_foreign_key "political_party_registrations", "countries", name: "fk_country"
  add_foreign_key "political_party_registrations", "political_parties", name: "fk_political_parties"
  add_foreign_key "result_summaries", "political_parties", column: "from_political_party_id", name: "fk_from_political_party"
  add_foreign_key "result_summaries", "political_parties", column: "to_political_party_id", name: "fk_to_political_party"
end
