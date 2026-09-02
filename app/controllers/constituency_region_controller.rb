class ConstituencyRegionController < ApplicationController

  def index
    country = params[:country]
    @country = Country.find( country )
    
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
    
    raise ActionController::RoutingError.new('Not Found') if @regions.empty?
    
    @page_title = "#{@country.name} - Regions"
    @multiline_page_title = "#{@country.name} <span class='subhead'>Regions</span>".html_safe
    @description = "Regions in #{@country.name}."
    @crumb << { label: 'Constituencies', url: constituency_list_url }
    @crumb << { label: @country.name, url: constituency_country_show_url }
    @crumb << { label: 'Regions', url: nil }
    @section = 'constituencies'
  end
  
  def show
    country = params[:country]
    @country = Country.find( country )
    
    region = params[:region]
    @region = EnglishRegion.find( region )
    
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
          AND ca.english_region_id = ?
          ORDER BY ca.name
        ", @country, @region
      ]
    )
    raise ActionController::RoutingError.new('Not Found') if @constituencies.empty?
    
    respond_to do |format|
      format.csv {
        csv_response_headers( "#{@country.name} #{@region.name} constituencies" )
        render :template => 'constituency/index'
      }
      format.html {
        @page_title = "#{@country.name} - #{@region.name}"
        @multiline_page_title = "#{@country.name} <span class='subhead'>#{@region.name}</span>".html_safe
        @description = "#{@country.name}, #{@region.name}."
        @csv_url = constituency_region_show_url( :format => 'csv' )
        @crumb << { label: 'Constituencies', url: constituency_list_url }
        @crumb << { label: @country.name, url: constituency_country_show_url }
        @crumb << { label: 'Regions', url: nil }
        @section = 'constituencies'
      }
    end
  end
end
