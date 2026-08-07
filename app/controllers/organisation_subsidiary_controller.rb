class OrganisationSubsidiaryController < ApplicationController

  def index
    organisation = params[:organisation]
    @organisation = Organisation.find( organisation )
    
    @subsidiary_organisations = Organisation.where( "parent_organisation_id = ?", @organisation.id )
    
    @parent_organisation = Organisation.find( @organisation.parent_organisation_id ) if @organisation.parent_organisation_id
    
    @page_title = "#{@organisation.label} - subsidiaries"
    @multiline_page_title = "#{@organisation.label} <span class='subhead'>Subsidiaries</span>".html_safe
    @description = "#{@organisation.label} subsidiaries."
    @crumb << { label: 'Organisations', url: organisation_list_url }
    @crumb << { label: @organisation.label, url: organisation_show_url }
    @crumb << { label: 'Subsidiaries', url: nil }
    @section = 'organisations'
    @subsection = 'subsidiaries'
  end
end
