class OrganisationTypeController < ApplicationController

  def index
    @organisation_types = OrganisationType.all.order( 'label' )
    
    respond_to do |format|
      format.csv {
        csv_response_headers( "Organisation types" )
      }
      format.html {
        @page_title = "Organisation types"
        @description = "Organisation types."
        @csv_url = organisation_type_list_url( :format => 'csv' )
        @crumb << { label: @page_title, url: nil }
        @section = 'organisation-types'
      }
    end
  end
  
  def show
    organistion_type = params[:organisation_type]
    @organisation_type = OrganisationType.find( organistion_type )
    
    @organisations = Organisation.find_by_sql(
      [
        "
          SELECT o.*
          FROM organisations o, organisation_typings ots
          WHERE o.id = ots.organisation_id
          AND ots.organisation_type_id = ?
          ORDER BY o.label
        ", @organisation_type
      ]
    )
    
    respond_to do |format|
      format.csv {
        csv_response_headers( @organisation_type.label )
      }
      format.html {
        @page_title = @organisation_type.label.pluralize
        @description = "#{@organisation_type.label.pluralize}."
        @csv_url = organisation_type_show_url( :format => 'csv' )
        @crumb << { label: 'Organisation types', url: organisation_type_list_url }
        @crumb << { label: @page_title, url: nil }
        @section = 'organisation-types'
      }
    end
  end
end
