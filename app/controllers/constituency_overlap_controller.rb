class ConstituencyOverlapController < ApplicationController

  def index
    constituency = params[:constituency]
    @constituency = ConstituencyArea.find_by_sql(
      [
        "
          SELECT ca.*,
            constituency_area_type.area_type AS constituency_type_label,
            country.id AS country_id,
            country.name AS country_name,
            region.id AS region_id,
            region.name AS region_name
          FROM constituency_areas ca
        
          INNER JOIN (
            SELECT *
            FROM constituency_area_types
          ) AS constituency_area_type
          ON constituency_area_type.id = ca.constituency_area_type_id
        
          INNER JOIN (
            SELECT *
            FROM countries
          ) AS country
          ON country.id = ca.country_id
        
          LEFT JOIN (
            SELECT *
            FROM english_regions
          ) AS region
          ON region.id = ca.english_region_id
        
          WHERE ca.id = ?
        ", constituency
      ]
    ).first
  
    @election = Election.find_by_sql(
      [
        "
          SELECT e.*,
            winning_candidacy.candidate_given_name AS winning_candidacy_given_name,
            winning_candidacy.candidate_family_name AS winning_candidacy_family_name,
            winning_candidacy.mnis_id AS winning_candidacy_mnis_id,
            winning_candidacy.is_standing_as_commons_speaker AS winning_candidacy_is_standing_as_commons_speaker,
            winning_candidacy.is_standing_as_independent AS winning_candidacy_is_standing_as_independent,
            main_party.id AS winning_candidacy_main_party_id,
            main_party.name AS winning_candidacy_main_party_name,
            main_party.mnis_id AS winning_candidacy_main_party_mnis_id,
            adjunct_party.name AS winning_candidacy_adjunct_party_name
          FROM elections e
        
          INNER JOIN (
            SELECT *
            FROM constituency_groups cg
            WHERE cg.constituency_area_id = ?
          ) AS constituency_group
          ON constituency_group.id = e.constituency_group_id
        
          INNER JOIN (
            SELECT cand.*, m.mnis_id
            FROM candidacies AS cand, members m
            WHERE cand.is_winning_candidacy IS TRUE
            AND cand.member_id = m.id
          ) AS winning_candidacy
          ON winning_candidacy.election_id = e.id
        
          LEFT JOIN (
            SELECT pp.*, cert.candidacy_id AS candidacy_id
            FROM political_parties pp, certifications cert
            WHERE pp.id = cert.political_party_id
            AND cert.adjunct_to_certification_id IS NULL
          ) AS main_party
          ON main_party.candidacy_id = winning_candidacy.id
        
          LEFT JOIN (
            SELECT pp.*, cert.candidacy_id AS candidacy_id
            FROM political_parties pp, certifications cert
            WHERE pp.id = cert.political_party_id
            AND cert.adjunct_to_certification_id IS NOT NULL
          ) AS adjunct_party
          ON adjunct_party.candidacy_id = winning_candidacy.id
        
          WHERE e.is_notional IS FALSE
          AND e.polling_on < ?
          ORDER BY e.polling_on DESC
        
        ", @constituency, Date.today
      ]
    ).first
  
    @organisations = Organisation.find_by_sql(
      [
        "
          SELECT
            o.*,
            caoo.constituency_area_population_overlap,
            ot.id AS organisation_type_id,
            ot.label AS organisation_type_label
          FROM organisations o, constituency_area_organisation_overlaps caoo, organisation_types ot
          WHERE o.id = caoo.organisation_id
          AND caoo.constituency_area_id = ?
          AND caoo.organisation_type_id = ot.id
          ORDER BY o.label
        ", @constituency
      ] 
    )
  
    @page_title = "#{@constituency.name} - overlaps"
    @multiline_page_title = "#{@constituency.name} <span class='subhead'>Overlaps</span>".html_safe
    @description = "#{@constituency.name} organisational overlaps."
    @crumb << { label: 'Constituencies', url: constituency_list_url }
    @crumb << { label: @constituency.name, url: constituency_show_url }
    @crumb << { label: 'Overlaps', url: nil }
    @section = 'constituencies'
    @subsection = 'overlaps'
  end
end
