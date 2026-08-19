class ResponsibilityController < ApplicationController
  
  def index
    @responsibilities = Responsibility.all.order( 'label' )
    
    @page_title = "Responsibilities"
    @description = "Responsibilities."
    @crumb << { label: @page_title, url: nil }
    @section = 'responsibilities'
  end
  
  def show
    responsibility = params[:responsibility]
    @responsibility = Responsibility.find( responsibility )
    
    @constituency_responsibilities = ConstituencyResponsibility.find_by_sql(
      [
        "
          SELECT
            cr.*,
            o.label AS organisation_label,
            ca.name AS constituency_name,
            caoo.constituency_area_population_overlap AS population_overlap
          FROM
            constituency_responsibilities cr,
            organisations o,
            constituency_areas ca,
            constituency_area_organisation_overlaps caoo
          WHERE cr.organisation_id = o.id
          AND cr.constituency_area_id = ca.id
          AND cr.constituency_area_organisation_overlap_id = caoo.id
          AND cr.responsibility_id = ?
          ORDER BY
            o.label,
            ca.name
        ", @responsibility
      ]
    )
    
    @page_title = @responsibility.label
    @description = "#{@responsibility.label}."
    @crumb << { label: 'Responsibilities', url: responsibility_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'responsibilities'
  end
end
