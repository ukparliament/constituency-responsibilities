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
    
    @responsibilities = ConstituencyResponsibility.find_by_sql(
      [
        "
          SELECT
            cr.*,
            ca.name AS constituency_name,
            r.label AS responsibility_label,
            caoo.constituency_area_population_overlap AS population_overlap
          FROM
            constituency_responsibilities cr,
            constituency_areas ca,
            responsibilities r,
            constituency_area_organisation_overlaps caoo
          WHERE cr.responsibility_id = r.id
          AND cr.constituency_area_id = ca.id
          AND cr.constituency_area_organisation_overlap_id = caoo.id
          AND cr.organisation_id = ?
          ORDER BY
            r.label,
            ca.name
        ", @organisation
      ]
    )
    
    @parent_organisation = Organisation.find( @organisation.parent_organisation_id ) if @organisation.parent_organisation_id
    
    @page_title = "#{@organisation.label} - responsibilities"
    @multiline_page_title = "#{@organisation.label} <span class='subhead'>Constituency responsibilities</span>".html_safe
    @description = "#{@organisation.label} constituency responsibilities."
    @crumb << { label: 'Organisations', url: organisation_list_url }
    @crumb << { label: @organisation.label, url: nil }
    @section = 'organisations'
    @subsection = 'responsibilities'
    
    render :template => 'organisation_responsibility/index'
  end
end
