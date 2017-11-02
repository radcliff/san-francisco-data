require 'spec_helper'
require 'san_francisco_data'

describe SanFranciscoData do
  before do
    VCR.insert_cassette :sfdata, record: :none, match_requests_on: [:uri], allow_playback_repeats: true
    @sfdata = SanFranciscoData.new

    @since_beginning_of_today     = 1501138800  # Time.now.beginning_of_day on 7/27/17
    @since_beginning_of_yesterday = 1501052400  # Time.now.beginning_of_day - 1.day on 7/27/17
  end

  after do
    VCR.eject_cassette
  end

  it 'fetches a list of 311 cases from SF Data' do
    expected_keys = [
      "status_description",
      "address",
      "service_name",
      "service_request_id",
      "source",
      "status_notes",
      "long",
      "agency_responsible",
      "service_subtype",
      "service_details",
      "requested_datetime",
      "updated_datetime",
      "lat"
    ]

    cases = @sfdata.fetch_311_cases(@since_beginning_of_yesterday)

    expect(cases).to be_an_instance_of(Array)
    expect(cases.count).to be > 0
    expect(cases.first.keys).to include(*expected_keys)
  end

  it 'filters list of 311 cases by `since` parameter' do
    all_cases = @sfdata.fetch_311_cases(@since_beginning_of_yesterday)
    filtered_cases = @sfdata.fetch_311_cases(@since_beginning_of_today)

    expect(all_cases.count).to be > filtered_cases.count
    expect(filtered_cases.count).to eq(2)  # see vcr cassette
  end
end
