class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  include LibraryDesign::Crumbs
  
  $SITE_TITLE = 'Constituency Responsibilities'
  
private

  #def csvify_title( csv_title )
    #csv_title.downcase.gsub( ' ', '-' )
  #end
  
  def csv_response_headers( title )
    title = title.downcase.gsub( ' ', '-' )
    response.headers['Content-Disposition'] = "attachment; filename=\"#{title}.csv\""
  end
end
