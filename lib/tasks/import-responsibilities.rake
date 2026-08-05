require 'csv'

task :import_responsibilities => [
  :import_organisation_types,
  :import_organisations,
  :import_organisation_typings,
  :import_constituency_area_organisation_overlaps,
  :add_parent_organisations
]

task :import_organisation_types => :environment do
  puts "importing organisation types"
  
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
  end
end

task :import_organisations => :environment do
  puts "importing organisations"
  
  # We set the path to the responsibilities by constituency CSV.
  responsibilities_by_constituency_csv = 'db/data/responsibilities_by_constituency.csv'
  
  # For each row in the sheet ...
  CSV.foreach( responsibilities_by_constituency_csv ).with_index do |row, index|
  
    # ... we skip the first row
    next if index == 0
    
    # We store the organisation code and label.
    organisation_code = row[2]
    organisation_label = row[3]
    
    # We attempt to find an organisation with this code and this label.
    organisation = Organisation.find_by( code: organisation_code, label: organisation_label )
    
    # Unless we find an organisation with this code and this label ...
    unless organisation
    
      # ... we create an organisation with this code and label.
      organisation = Organisation.new
      organisation.code = organisation_code
      organisation.label = organisation_label
      organisation.save!
    end
  end
end

task :import_organisation_typings => :environment do
  puts "importing organisation typings"
  
  # We set the path to the responsibilities by constituency CSV.
  responsibilities_by_constituency_csv = 'db/data/responsibilities_by_constituency.csv'
  
  # For each row in the sheet ...
  CSV.foreach( responsibilities_by_constituency_csv ).with_index do |row, index|
  
    # ... we skip the first row
    next if index == 0
    
    # We store the organisation type label.
    organisation_type_label = row[4].strip
    
    # We find an organisation type with this label.
    organisation_type = OrganisationType.find_by_label( organisation_type_label )
    
    # We store the organisation code and label.
    organisation_code = row[2]
    organisation_label = row[3]
    
    # We find an organisation with this code and this label.
    organisation = Organisation.find_by( code: organisation_code, label: organisation_label )
    
    # We attempt to find an organisation typing for this organisation with this type.
    organisation_typing = OrganisationTyping.find_by( organisation_id: organisation.id, organisation_type_id: organisation_type.id )
    
    # Unless we find an organisation typing for this organisation with this type ...
    unless organisation_typing
    
      # ... we create a new organisation typing for this organisation with this type.
      organisation_typing = OrganisationTyping.new
      organisation_typing.organisation = organisation
      organisation_typing.organisation_type = organisation_type
      organisation_typing.save!
    end
  end
end

task :import_constituency_area_organisation_overlaps => :environment do
  puts "importing constituency area organisation overlaps"
  
  # We set the path to the responsibilities by constituency CSV.
  responsibilities_by_constituency_csv = 'db/data/responsibilities_by_constituency.csv'
  
  # For each row in the sheet ...
  CSV.foreach( responsibilities_by_constituency_csv ).with_index do |row, index|
  
    # ... we skip the first row
    next if index == 0
    
    # We store the organisation code and label.
    organisation_code = row[2]
    organisation_label = row[3]
    
    # We find the organisation with this code and this label.
    organisation = Organisation.find_by( code: organisation_code, label: organisation_label )
    
    # We store the constituency area geographic code.
    constituency_area_geographic_code = row[0]
  
    # We find the constituency area with this code in a current boundary set.
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
    
    # We store the organisation type label.
    organisation_type_label = row[4].strip
    
    # We find an organisation type with this label.
    organisation_type = OrganisationType.find_by_label( organisation_type_label )
    
    # We store the constituency area population overlap.
    constituency_area_population_overlap = row[5]
  
    # We look for a constituency area organisation overlap for this constituency, this organisation and this organisation type.
    constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap
      .where( "constituency_area_id = ?", constituency_area )
      .where( "organisation_id = ?", organisation.id )
      .where( "organisation_type_id = ?", organisation_type.id )
      .first
      
    # Unless we find a constituency area organisation overlap for this constituency, this organisation and this organisation type ...
    unless constituency_area_organisation_overlap
  
      # ... we create a constituency area organisation overlap for this constituency, this organisation and this organisation type.
      constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap.new
      constituency_area_organisation_overlap.constituency_area = constituency_area
      constituency_area_organisation_overlap.organisation = organisation
      constituency_area_organisation_overlap.organisation_type = organisation_type
    end
  
    # We update the constituency area population overlap.
    constituency_area_organisation_overlap.constituency_area_population_overlap = constituency_area_population_overlap
    constituency_area_organisation_overlap.save!
  end
end

task :add_parent_organisations => :environment do
  puts "adding parent organisations"
  
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