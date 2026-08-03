class OrganisationTypeController < ApplicationController

  def index
    @organisation_types = OrganisationType.all.order( 'label' )
    
    @page_title = "Organisation types"
    @description = "Organisation types."
    @crumb << { label: @page_title, url: nil }
    @section = 'organisation-types'
  end
  
  def show
    organistion_type = params[:organisation_type]
    @organisation_type = OrganisationType.find( organistion_type )
    
    @page_title = @organisation_type.label.pluralize
    @description = "#{@organisation_type.label.pluralize}."
    @crumb << { label: 'Organisation types', url: organisation_type_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'organisation-types'
  end
end
