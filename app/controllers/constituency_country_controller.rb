class ConstituencyCountryController < ApplicationController

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
    
    @page_title = "Countries"
    @description = "Countries."
    @crumb << { label: 'Constituencies', url: constituency_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'constituencies'
  end
  
  def show
    country = params[:country]
    @country = Country.find( country )
    
    @constituencies = ConstituencyArea.find_by_sql(
      [
        "
          SELECT ca.*
          FROM constituency_areas ca, boundary_sets bs
          WHERE ca.boundary_set_id = bs.id
          AND bs.end_on IS NULL
          AND ca.country_id = ?
          ORDER BY ca.name
        ", @country
      ]
    )
    
    @regions = EnglishRegion.find_by_sql(
      [
        "
          SELECT *
          FROM english_regions
          WHERE country_id = ?
          ORDER BY name
        ", @country
      ]
    )
    
    @page_title = @country.name
    @description = "#{@country.name}."
    @crumb << { label: 'Constituencies', url: constituency_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'constituencies'
  end
end
