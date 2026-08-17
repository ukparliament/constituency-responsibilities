task :backfill_overlaps => [
  :backfill_scotland_overlaps,
  :backfill_northern_ireland_overlaps
]

task :backfill_scotland_overlaps => :environment do
  puts "backfilling scotland overlaps"
  
  # We attempt to find an organisation typing for Police Scotland.
  organisation_typing = OrganisationTyping
    .where( 'organisation_id = 952')
    .where( 'organisation_type_id = 14' )
    .first
    
  # Unless we find an organisation typing for Police Scotland ...
  unless organisation_typing
  
    # ... we create one.
    organisation_typing = OrganisationTyping.new
    organisation_typing.organisation_id = 952
    organisation_typing.organisation_type_id = 14
    organisation_typing.save!
  end
  
  # We attempt to find an organisation typing for Scottish Fire and Rescue Service.
  organisation_typing = OrganisationTyping
    .where( 'organisation_id = 950')
    .where( 'organisation_type_id = 3' )
    .first
    
  # Unless we find an organisation typing for Scottish Fire and Rescue Service ...
  unless organisation_typing
  
    # ... we create one.
    organisation_typing = OrganisationTyping.new
    organisation_typing.organisation_id = 950
    organisation_typing.organisation_type_id = 3
    organisation_typing.save!
  end
  
  # We get all the current constituencies in Scotland.
  constituencies = ConstituencyArea.find_by_sql(
    "
      SELECT ca.*
      FROM constituency_areas ca, boundary_sets bs
      WHERE ca.boundary_set_id = bs.id
      AND bs.end_on IS NULL
      AND ca.country_id = 5
    "
  )
  
  # We find the organisations in Scotland with no overlap data.
  organisations = Organisation.find_by_sql(
    "
      SELECT o.*
      FROM organisations o
      WHERE label = 'Police Scotland'
      OR label = 'Scottish Fire and Rescue Service'
    "
  )
  
  # For each organisation ...
  organisations.each do |organisation|
  
    # ... we get their type.
    organisation_type = OrganisationType.find_by_sql(
      [
        "
          SELECT ot.*
          FROM organisation_types ot, organisation_typings ots
          WHERE ot.id = ots.organisation_type_id
          AND ots.organisation_id = ?
        ", organisation
      ]
    ).first
    
    # For each constituency area ...
    constituencies.each do |constituency|
    
      # ... we attempt to find an overlap of this organisation, of this type, in this constituency.
      constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap
        .where( 'organisation_id = ?', organisation )
        .where( 'organisation_type_id = ?', organisation_type )
        .where( 'constituency_area_id = ?', constituency )
        .first
        
      # Unless we find an overlap of this organisation, of this type, in this constituency ...
      unless constituency_area_organisation_overlap
      
        # ... we create one.
        constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap.new
        constituency_area_organisation_overlap.organisation = organisation
        constituency_area_organisation_overlap.organisation_type = organisation_type
        constituency_area_organisation_overlap.constituency_area = constituency
        constituency_area_organisation_overlap.constituency_area_population_overlap = 100
        constituency_area_organisation_overlap.save!
      end
    end
  end
end

task :backfill_northern_ireland_overlaps => :environment do
  puts "backfilling Northern Ireland overlaps"
  
  # We attempt to find an organisation type of Electoral Authorities.
  organisation_type = OrganisationType.find_by_label( 'Electoral Authorities' )
  
  # Unless we find an organisation type of Electoral Authorities ...
  unless organisation_type
  
    # ... we create it.
    organisation_type = OrganisationType.new
    organisation_type.label = 'Electoral Authorities'
    organisation_type.save!
  end
  
  # We attempt to find an organisation typing of the Electoral Office of Northern Ireland as an Electoral Authority.
  organisation_typing = OrganisationTyping
    .where( 'organisation_id = ?', 955 )
    .where( 'organisation_type_id = ?', organisation_type.id )
    .first
  
  # Unless we find an organisation typing of the Electoral Office of Northern Ireland as an Electoral Authority ...
  unless organisation_typing
  
    # ... we create it.
    organisation_typing = OrganisationTyping.new
    organisation_typing.organisation_id = 955
    organisation_typing.organisation_type_id = organisation_type.id
    organisation_typing.save!
  end
  
  # We attempt to find an organisation type of Devolved governments.
  organisation_type = OrganisationType.find_by_label( 'Devolved governments' )
  
  # Unless we find an organisation type of Devolved governments ...
  unless organisation_type
  
    # ... we create it.
    organisation_type = OrganisationType.new
    organisation_type.label = 'Devolved governments'
    organisation_type.save!
  end
  
  # We attempt to find an organisation typing of the Northern Ireland Executive as a devolved government.
  organisation_typing = OrganisationTyping
    .where( 'organisation_id = ?', 954 )
    .where( 'organisation_type_id = ?', organisation_type.id )
    .first
  
  # Unless we find an organisation typing of the Northern Ireland Executive as a devolved government ...
  unless organisation_typing
  
    # ... we create it.
    organisation_typing = OrganisationTyping.new
    organisation_typing.organisation_id = 954
    organisation_typing.organisation_type_id = organisation_type.id
    organisation_typing.save!
  end
              
  # We attempt to find an organisation typing for the Northern Ireland Fire and Rescue Service.
  organisation_typing = OrganisationTyping
    .where( 'organisation_id = 951' )
    .where( 'organisation_type_id = 3' )
    .first
    
  # Unless we find an organisation typing for the Northern Ireland Fire and Rescue Service ...
  unless organisation_typing
  
    # ... we create one.
    organisation_typing = OrganisationTyping.new
    organisation_typing.organisation_id = 951
    organisation_typing.organisation_type_id = 3
    organisation_typing.save!
  end
  
  # We attempt to find an organisation typing for the Police Service of Northern Ireland.
  organisation_typing = OrganisationTyping
    .where( 'organisation_id = 953' )
    .where( 'organisation_type_id = 14' )
    .first
    
  # Unless we find an organisation typing for the Police Service of Northern Ireland ...
  unless organisation_typing
  
    # ... we create one.
    organisation_typing = OrganisationTyping.new
    organisation_typing.organisation_id = 953
    organisation_typing.organisation_type_id = 14
    organisation_typing.save!
  end
  
  # We get all the current constituencies in Northern Ireland.
  constituencies = ConstituencyArea.find_by_sql(
    "
      SELECT ca.*
      FROM constituency_areas ca, boundary_sets bs
      WHERE ca.boundary_set_id = bs.id
      AND bs.end_on IS NULL
      AND ca.country_id = 4
    "
  )
  
  # We find the organisations in Northern Ireland with no overlap data.
  organisations = Organisation.find_by_sql(
    "
      SELECT o.*
      FROM organisations o
      WHERE label = 'Northern Ireland Fire and Rescue Service'
      OR label = 'Police Service of Northern Ireland'
      OR label = 'Electoral Office of Northern Ireland'
      OR label = 'Northern Ireland Executive'
    "
  )
  
  # For each organisation ...
  organisations.each do |organisation|
  
    # ... we get their type.
    organisation_type = OrganisationType.find_by_sql(
      [
        "
          SELECT ot.*
          FROM organisation_types ot, organisation_typings ots
          WHERE ot.id = ots.organisation_type_id
          AND ots.organisation_id = ?
        ", organisation
      ]
    ).first
    
    # For each constituency area ...
    constituencies.each do |constituency|
    
      # ... we attempt to find an overlap of this organisation, of this type, in this constituency.
      constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap
        .where( 'organisation_id = ?', organisation )
        .where( 'organisation_type_id = ?', organisation_type )
        .where( 'constituency_area_id = ?', constituency )
        .first
        
      # Unless we find an overlap of this organisation, of this type, in this constituency ...
      unless constituency_area_organisation_overlap
      
        # ... we create one.
        constituency_area_organisation_overlap = ConstituencyAreaOrganisationOverlap.new
        constituency_area_organisation_overlap.organisation = organisation
        constituency_area_organisation_overlap.organisation_type = organisation_type
        constituency_area_organisation_overlap.constituency_area = constituency
        constituency_area_organisation_overlap.constituency_area_population_overlap = 100
        constituency_area_organisation_overlap.save!
      end
    end
  end
end





