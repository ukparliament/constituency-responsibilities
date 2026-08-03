class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  include LibraryDesign::Crumbs
  
  $SITE_TITLE = 'Constituency Responsibilities'
end
