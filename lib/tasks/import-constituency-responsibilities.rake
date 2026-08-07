require 'csv'

task :import_constituency_responsibilities => [
  :import_responsibility_list,
  :import_constituency_responsibilites_join
]

task :import_responsibility_list => :environment do
  puts "importing responsibilities"
  
  # We set the path to the responsibilities CSV.
  responsibilities_csv = 'db/data/responsibilities.csv'
  
  # For each row in the sheet ...
  CSV.foreach( responsibilities_csv ).with_index do |row, index|
  
    # ... we skip the first row
    next if index == 0
    
    # We store the responsibility label.
    responsibility_label = row[3].strip
    
    # We attempt to find a responsibility with this label.
    responsibility = Responsibility.find_by_label( responsibility_label )
    
    # Unless we find a responsibility with this label ...
    unless responsibility
    
      # ... we create a new responsibility with this label.
      responsibility = Responsibility.new
      responsibility.label = responsibility_label
      responsibility.save!
    end
  end
end

task :import_constituency_responsibilites_join => :environment do
  puts "importing the join from constituencies to responsibilities"
  
  # We set the path to the responsibilities CSV.
  responsibilities_csv = 'db/data/responsibilities.csv'
  
  # For each row in the sheet ...
  CSV.foreach( responsibilities_csv ).with_index do |row, index|
  
    # ... we skip the first row
    next if index == 0
    
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
    
     # We store the responsibility label.
    responsibility_label = row[3].strip
    
    # We find a responsibility with this label.
    responsibility = Responsibility.find_by_label( responsibility_label )
    
    # We store the organisation label.
    organisation_label = row[2].strip
    
    # We split the organisation label into an organisation label array.
    organisation_label_array = organisation_label.split( ';' )
    
    # For each organisation label in the organisation label array ...
    organisation_label_array.each do |organisation_split_label|
    
      # ... if the split label contains ' (part of ' ...
      if organisation_split_label.include?( ' (part of ' )
      
        # ... we strip ' (part of ' from the split label.
        organisation_split_label = strip_out_part_of( organisation_split_label )
      end
    
      # ... we attempt to find an organisation with this label.
      organisation = Organisation.find_by_label( organisation_split_label.strip )
      
      # If we fail to find an organisation with this label ...
      unless organisation
      
        # ... we create an organisation with this label.
        organisation = Organisation.new
        organisation.label = organisation_split_label
        organisation.save!
      end
      
      # We attempt to find a constituency responsibility for this constituency area, with this responsibility for this organisation.
      constituency_responsibility = ConstituencyResponsibility.find_by_sql(
        [
          "
            SELECT cr.*
            FROM constituency_responsibilities cr
            WHERE cr.constituency_area_id = ?
            AND cr.organisation_id = ?
            AND cr.responsibility_id = ?
          ", constituency_area, organisation, responsibility
        ]
      ).first
      
      # Unless we find a constituency responsibility for this constituency area, with this responsibility for this organisation ...
      unless constituency_responsibility
      
        # ... we create a constituency responsibility for this constituency area, with this responsibility for this organisation ...
        constituency_responsibility = ConstituencyResponsibility.new
        constituency_responsibility.constituency_area = constituency_area
        constituency_responsibility.organisation = organisation
        constituency_responsibility.responsibility = responsibility
        constituency_responsibility.save!
      end
    end
  end
end

# A method to strip ' (part of ' from organisation names.
def strip_out_part_of( organisation_split_label )
  organisation_split_label = organisation_split_label.split( ' (part of ' ).first.strip
end


# Organisations that are in the responsibilities file but not in overlaps.

# Electoral Office of Northern Ireland
# Northern Ireland Executive
# Northern Ireland Fire and Rescue Service
# Police Service of Northern Ireland

# Police Scotland
# Scottish Fire and Rescue Service

