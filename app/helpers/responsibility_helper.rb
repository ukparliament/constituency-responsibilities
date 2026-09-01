module ResponsibilityHelper

  def responsibility_disclaimer
    responsibility_disclaimer = content_tag( 'p', "Responsibilities are taken from a taxonomy created by the House of Commons Library. They are to be read as indicative, not as a comprehensive list of all responsibilities an organisation may have, statutory or otherwise.", :class => 'zero-population-overlap-disclaimer' )
    responsibility_disclaimer = content_tag( 'div', responsibility_disclaimer, :class => 'highlight highlight-info' )
  end
end
