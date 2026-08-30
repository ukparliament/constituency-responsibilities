module ApplicationHelper

  # A method to check if the array passed includes an object with a population overlap of zero.
  def zero_percent_disclaimer( array )
  
    # We set the zero percent disclaimer text to nil.
    zero_percent_disclaimer = nil
    
    puts array.any? {|item| item.population_overlap == 0 }
  
    # If the array includes an object with a population overlap of zero ...
    if array.any? {|item| item.population_overlap == 0 }
    
      # ... we set the zero percent overlap disclaimer text ...
      zero_percent_disclaimer = content_tag( 'p', "Where percentage figures are not given, it is known that some members of the population of the constituency are covered by the organisation, but that area is too small to produce a population estimate using the standard methods.", :class => 'zero-population-overlap-disclaimer' )
      
      # ... and wrap it in a highlight.
      zero_percent_disclaimer = content_tag( 'div', zero_percent_disclaimer, :class => 'highlight highlight-info' )
    end
    
    # We return the zero percent disclaimer.
    zero_percent_disclaimer
  end
end
