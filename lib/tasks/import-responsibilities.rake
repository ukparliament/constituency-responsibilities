require 'csv'

# ## A task to import constituency responsibilities.
task :import_responsibilities => :environment do
  puts "importing constituency responsibilities"
  
  # We set the path to the responsibilities by constituency CSV.
  responsibilities_by_constituency_csv = 'db/data/responsibilities_by_constituency.csv'
  
  # For each row in the sheet ...
  CSV.foreach( responsibilities_by_constituency_csv ).with_index do |row, index|
  
    # ... we skip the first row
    next if index == 0
    
    # We store the organisation type label.
    organisation_type_label = row[4].strip
    
    # We attempt to find an organisation type with this label.
    organisation_type = OrganisationType.find_by_label( organisation_type_label )
    
    # Unless we find an organisation type with this label ...
    unless organisation_type
    
      # ... we create a new organisation type.
      organisation_type = OrganisationType.new
      organisation_type.label = organisation_type_label
      organisation_type.save!
    end
    
    # We store the organisation code and label.
    organisation_code = row[2]
    organisation_label = row[3]
    
    # We attempt to find an organisation with this code and this label.
    organisation = Organisation.find_by( code: organisation_code, label: organisation_label )
    
    # Unless we find an organisation with this code and this label and this type ...
    unless organisation
    
      # ... we create an organisation with this code and label.
      organisation = Organisation.new
      organisation.code = organisation_code
      organisation.label = organisation_label
      organisation.organisation_type = organisation_type
      organisation.save!
    end
    
    # We store the constituency area geographic code.
    constituency_area_geographic_code = row[0]
    
    # We find the constituency area.
    constituency_area = ConstituencyArea.find_by_sql(
      [
        "
          SELECT ca.*
          FROM constituency_areas ca, boundary_sets bs
          WHERE ca.geographic_code = ?
          AND ca.boundary_set_id = bs.id
          AND bs.end_on IS NULL
        ", constituency_area_geographic_code
      ]
    ).first
    
    # We store the constituency area population overlap.
    constituency_area_population_overlap = row[5]
    
    # We look for a constituency area organisation overlap for this constituency and this organisation.
    constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap
      .where( "constituency_area_id = ?", constituency_area )
      .where( "organisation_id = ?", organisation.id )
      .first
      
    # Unless we find a constituency area organisation overlap for this constituency and this organisation ...
    unless constituency_area_organisation_overlap
    
      # ... we create a constituency area organisation overlap for this constituency and this organisation.
      constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap.new
      constituency_area_organisation_overlap.constituency_area = constituency_area
      constituency_area_organisation_overlap.organisation = organisation
    end
    
    # We update the constituency area population overlap.
    constituency_area_organisation_overlap.constituency_area_population_overlap = constituency_area_population_overlap
    constituency_area_organisation_overlap.save!
  end
  
  # We find all organisations.
  organisations = Organisation.all
  
  # For each organisation ...
  organisations.each do |organisation|
  
    # ... if the organisation label includes ' (part of ' ...
    if organisation.label.include?( ' (part of ' )
    
      # ... we split the label of the organisation on ' (part of '
      organisation_split_label = organisation.label.split( ' (part of ' )
      
      # We update the label of the organisation.
      organisation.label = organisation_split_label.first
      organisation.save!
      
      # We split the second part of the organisation split label on ')' and take the first part.
      organisation_split_label = organisation_split_label[1].split( ')' ).first
      
      # If the new organisation split label is 'South Staffs Water'
      if organisation_split_label == 'South Staffs Water'
      
        # ... we set the new organisation split label to 'South Staffordshire Water'.
        organisation_split_label = 'South Staffordshire Water'
        
        # We weep.
      end
      
      # We find the parent organisation with this label.
      parent_organisation = Organisation.find_by_label( organisation_split_label )
      
      # We set the parent organisation ID on the organisation
      organisation.parent_organisation_id = parent_organisation.id
      organisation.save!
    end
  end
end