class OrganisationHavingTypeController < ApplicationController

  def index
    organisation = params[:organisation]
    @organisation = Organisation.find( organisation )
    
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
    
    @page_title = "#{@organisation.label} - organisation types"
    @multiline_page_title = "#{@organisation.label} <span class='subhead'>Organisation types</span>".html_safe
    @description = "#{@organisation.label} organisation types."
    @crumb << { label: 'Organisations', url: organisation_list_url }
    @crumb << { label: @organisation.label, url: organisation_show_url }
    @crumb << { label: 'Types', url: nil }
    @section = 'organisations'
    @subsection = 'types'
  end
end
