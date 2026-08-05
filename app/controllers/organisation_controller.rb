class OrganisationController < ApplicationController

  def index
    @organisations = Organisation.all.order( 'label' )
    
    @page_title = "Organisations"
    @description = "Organisations."
    @crumb << { label: @page_title, url: nil }
    @section = 'organisations'
  end
  
  def show
    organisation = params[:organisation]
    @organisation = Organisation.find( organisation )
    
    @subsidiary_organisations = Organisation.where( "parent_organisation_id = ?", @organisation.id )
    
    @organisation_types = OrganisationType.find_by_sql(
      [
        "
          SELECT ot.*
          FROM organisation_types ot, organisation_typings ott
          WHERE ot.id = ott.organisation_type_id
          AND ott.organisation_id = ?
          ORDER BY ot.label
        ", @organisation
      ]
    )
    
    @parent_organisation = Organisation.find( @organisation.parent_organisation_id ) if @organisation.parent_organisation_id
    
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
    
    @page_title = @organisation.label
    @description = "#{@organisation.label}."
    @crumb << { label: 'Organisations', url: organisation_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'organisations'
  end
end
