task :apply_overlaps_to_responsibilities => :environment do
  puts "applying overlaps to responsibilities"
  
  # We get all the constituency responsibilities.
  constituency_responsibilities = ConstituencyResponsibility.all
  
  # For each constituency responsibility ...
  constituency_responsibilities.each do |constituency_responsibility|
  
    # ... if the organisation with the constituency responsibility has more than one type ...
    if constituency_responsibility.organisation.organisation_typings.size > 1
    
      # ... if the responsibility is 'Water supply' ...
      if constituency_responsibility.responsibility.label == 'Water supply'
      
        # ... we store the organisation_type ID as Water companies.
        organisation_type_id = 19
      
      # Otherwise, if the responsibility is 'Sewerage' ...
      elsif constituency_responsibility.responsibility.label == 'Sewerage'
      
        # ... we store the organisation_type ID as Sewerage companies.
        organisation_type_id = 20
      end
    
    # Otherwise, if the organisation with the constituency responsibility has more than one type ...
    else
    
      # ... we store the organisation type ID.
      organisation_type_id = constituency_responsibility.organisation.organisation_typings.first.organisation_type.id
    end
    
    # We find the constituency area organisation overlap of this constituency, for this organisation of this type.
    constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap
      .where( 'constituency_area_id = ?', constituency_responsibility.constituency_area_id )
      .where( 'organisation_id = ?', constituency_responsibility.organisation_id )
      .where( 'organisation_type_id = ?', organisation_type_id )
      .first
        
    # We apply the overlap to the responsibility.
    constituency_responsibility.constituency_area_organisation_overlap = constituency_area_organisation_overlap
    constituency_responsibility.save!
  end
end