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
    
    @constituencies = ConstituencyArea.find_by_sql (
      [
        "
          SELECT ca.*
          FROM constituency_areas ca, boundary_sets bs
          WHERE ca.country_id = ?
          AND ca.english_region_id = ?
          AND ca.boundary_set_id = bs.id
          AND bs.end_on IS NULL
          ORDER BY name
        ", @country, @region
      ]
    )
    
    raise ActionController::RoutingError.new('Not Found') if @constituencies.empty?
    
    @page_title = "#{@country.name} - #{@region.name}"
    @multiline_page_title = "#{@country.name} <span class='subhead'>#{@region.name}</span>".html_safe
    @description = "#{@country.name}, #{@region.name}."
    @crumb << { label: 'Constituencies', url: constituency_list_url }
    @crumb << { label: @country.name, url: constituency_country_show_url }
    @crumb << { label: 'Regions', url: nil }
    @section = 'constituencies'
  end
end
