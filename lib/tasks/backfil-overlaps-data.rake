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
  
              # TODO: create an organisation type for the Electoral Office of Northern Ireland.
              # Electoral Authorities / Electoral Service / ???
  
              # TODO: create an organisation type for the Northern Ireland Executive.
              # Devolved governments / Devolved executives / ???
              
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
  
          #Electoral Office of Northern Ireland
          #955 / ????
  
          #Northern Ireland Executive
          #954 / ???
  
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





