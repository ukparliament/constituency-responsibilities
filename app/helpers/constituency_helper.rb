module ConstituencyHelper

  def constituency_geographic_description( constituency )
    constituency_geographic_description = 'A '
    constituency_geographic_description += constituency.constituency_type_label.downcase
    constituency_geographic_description += ' constituency in '
    if constituency.region_name
      constituency_geographic_description += link_to( constituency.region_name, constituency_region_show_url( :country => constituency.country_id, :region => constituency.region_id ) )
      constituency_geographic_description += ', '
    end
    constituency_geographic_description += link_to( constituency.country_name, constituency_country_show_url( :country => constituency.country_id ) )
    constituency_geographic_description += ' with geographic code '
    constituency_geographic_description += constituency.geographic_code
    constituency_geographic_description += '.'
  end
  
  def constituency_last_election_description( election )
    constituency_last_election_description = 'The last election to this constituency was '
    constituency_last_election_description += constituency_last_election_link( election )
    constituency_last_election_description += '. It was won by '
    constituency_last_election_description += constituency_last_election_winning_candidacy_link( election )
    constituency_last_election_description += ', standing as '
    constituency_last_election_description += constituency_last_election_winning_candidacy_affiliation( election )
    constituency_last_election_description += '.'
  end
  
  def constituency_last_election_link( election )
    constituency_last_election_link = ''
    if election.general_election_id
      constituency_last_election_link += 'held as part of the general election on '
    else
      constituency_last_election_link += 'by-election held on '
    end
    constituency_last_election_link += election.polling_on.strftime( '%-d %B %Y' )
    constituency_last_election_link = link_to( constituency_last_election_link, "https://electionresults.parliament.uk/elections/#{election.id}" )
    if election.general_election_id
    else
      constituency_last_election_link = 'a ' + constituency_last_election_link
    end
    constituency_last_election_link
  end
  
  def constituency_last_election_winning_candidacy_link( election )
    winning_candidacy_link = constituency_last_election_winning_candidacy_name( election )
    winning_candidacy_link = link_to( winning_candidacy_link, "https://members.parliament.uk/member/#{election.winning_candidacy_mnis_id}" )
  end
  
  def constituency_last_election_winning_candidacy_name( election )
    winning_candidacy_link = election.winning_candidacy_given_name
    winning_candidacy_link += ' '
    winning_candidacy_link += election.winning_candidacy_family_name
  end
  
  def constituency_last_election_winning_candidacy_affiliation( election)
    constituency_last_election_winning_candidacy_affiliation = ''
    if election.winning_candidacy_is_standing_as_commons_speaker
      constituency_last_election_winning_candidacy_affiliation += 'the House of Commons Speaker'
    elsif election.winning_candidacy_is_standing_as_independent
      constituency_last_election_winning_candidacy_affiliation += 'an independent candidate'
    else
      constituency_last_election_winning_candidacy_affiliation += 'the '
      constituency_last_election_winning_candidacy_affiliation += link_to( election.winning_candidacy_main_party_name, "https://electionresults.parliament.uk/political-parties/#{election.winning_candidacy_main_party_id}" )
      if election.winning_candidacy_adjunct_party_name
        constituency_last_election_winning_candidacy_affiliation += ' / '
        constituency_last_election_winning_candidacy_affiliation += election.winning_candidacy_adjunct_party_name
      end
      constituency_last_election_winning_candidacy_affiliation += ' candidate'
    end
    constituency_last_election_winning_candidacy_affiliation
  end
end
