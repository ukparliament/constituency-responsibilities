class MetaController < ApplicationController

  def index
    @page_title = "About this website"
    @description = "About this website."
    @crumb << { label: @page_title, url: nil }
  end

  def cookies
    @page_title = "Cookie Policy"
    @description = "Cookie Policy."
    @crumb << { label: 'About this website', url: meta_list_url }
    @crumb << { label: @page_title, url: nil }
    render 'library_design/meta/cookies'
  end
end
