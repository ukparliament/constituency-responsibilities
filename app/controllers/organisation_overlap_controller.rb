class OrganisationOverlapController < ApplicationController

  def index
    organisation = params[:organisation]
    @organisation = Organisation.find( organisation )
    
    @constituencies = ConstituencyArea.find_by_sql(
      [
        "
          SELECT
            ca.*,
            caoo.constituency_area_population_overlap,
            ot.id AS organisation_type_id,
            ot.label AS organisation_type_label
          FROM constituency_areas ca, constituency_area_organisation_overlaps caoo, organisation_types ot
          WHERE ca.id = caoo.constituency_area_id
          AND caoo.organisation_type_id = ot.id
          AND caoo.organisation_id = ?
          ORDER BY ca.name
        ", @organisation
      ] 
    )
    
    @parent_organisation = Organisation.find( @organisation.parent_organisation_id ) if @organisation.parent_organisation_id
    
    @page_title = "#{@organisation.label} - constituency overlaps"
    @multiline_page_title = "#{@organisation.label} <span class='subhead'>Constituency overlaps</span>".html_safe
    @description = "#{@organisation.label} constituency overlaps."
    @crumb << { label: 'Organisations', url: organisation_list_url }
    @crumb << { label: @organisation.label, url: organisation_show_url }
    @crumb << { label: 'Overlaps', url: nil }
    @section = 'organisations'
    @subsection = 'overlaps'
  end
end
