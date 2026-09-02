class ConstituencyController < ApplicationController

  def index
    @countries = Country.find_by_sql(
      "
        SELECT c.*
        FROM countries c, constituency_areas ca
        WHERE c.id = ca.country_id
        GROUP BY c.id
        ORDER BY c.name
      "
    )
    
    @constituencies = ConstituencyArea.find_by_sql(
      "
        SELECT
          ca.*,
          constituency_area_type.area_type AS type_label,
          region.name AS region_name,
          region.geographic_code AS region_geographic_code,
          country.name AS country_name,
          country.geographic_code AS country_geographic_code
          
        FROM constituency_areas ca
        INNER JOIN (
          SELECT *
          FROM boundary_sets
          WHERE end_on IS NULL
        ) AS boundary_set
        ON ca.boundary_set_id = boundary_set.id
        INNER JOIN (
          SELECT *
          FROM constituency_area_types
        ) AS constituency_area_type
        ON ca.constituency_area_type_id = constituency_area_type.id
        LEFT JOIN (
          SELECT *
          FROM english_regions
        ) AS region
        ON ca.english_region_id = region.id
        INNER JOIN (
          SELECT *
          FROM countries
        ) AS country
        ON ca.country_id = country.id
        ORDER BY ca.name
      "
    )
    
    respond_to do |format|
      format.csv {
        csv_response_headers( "constituencies" )
        render :template => 'constituency/index'
      }
      format.html {
        @page_title = "Constituencies"
        @description = "Constituencies."
        @csv_url = constituency_list_url( :format => 'csv' )
        @crumb << { label: @page_title, url: nil }
        @section = 'constituencies'
      }
    end
  end
  
  def show
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
    
    @constituency_responsibilities = ConstituencyResponsibility.find_by_sql(
      [
        "
          SELECT
            cr.*,
            r.label AS responsibility_label,
            o.label AS organisation_label,
            caoo.constituency_area_population_overlap AS population_overlap
          FROM
            constituency_responsibilities cr,
            responsibilities r,
            organisations o,
            constituency_area_organisation_overlaps caoo
          WHERE cr.responsibility_id = r.id
          AND cr.organisation_id = o.id
          AND cr.constituency_area_id = ?
          AND cr.constituency_area_organisation_overlap_id = caoo.id
          ORDER BY
            r.label,
            o.label
        ", @constituency
      ]
    )
    
    @page_title = "#{@constituency.name} - responsibilities"
    @multiline_page_title = "#{@constituency.name} <span class='subhead'>Responsibilites</span>".html_safe
    @description = "#{@constituency.name} organisational responsibilities."
    @csv_url = constituency_responsibility_list_url( :format => 'csv' )
    @crumb << { label: 'Constituencies', url: constituency_list_url }
    @crumb << { label: @constituency.name, url: nil }
    @section = 'constituencies'
    @subsection = 'responsibilities'
    
    render :template => 'constituency_responsibility/index'
  end
end
