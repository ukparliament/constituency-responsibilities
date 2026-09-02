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
          LEFT JOIN (
            SELECT *
            FROM countries
          ) AS country
          ON ca.country_id = country.id
          WHERE ca.country_id = ?
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
    
    respond_to do |format|
      format.csv {
        csv_response_headers( "#{@country.name} constituencies" )
        render :template => 'constituency/index'
      }
      format.html {
        @page_title = @country.name
        @description = "Constituencies in #{@country.name}."
        @csv_url = constituency_country_show_url( :format => 'csv' )
        @crumb << { label: 'Constituencies', url: constituency_list_url }
        @crumb << { label: @page_title, url: nil }
        @section = 'constituencies'
      }
    end
  end
end
