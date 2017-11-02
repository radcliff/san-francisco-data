class SanFranciscoData
  SF_311_DATA_SOURCE = 'http://data.sfgov.org/resource/vw6y-z8j6.json'
  BEGINNING_OF_YESTERDAY = (Time.now.beginning_of_day - 1.day).to_i

  def fetch_311_cases(since = BEGINNING_OF_YESTERDAY)
    response = Faraday.get(SF_311_DATA_SOURCE)
    raise "An error ocurred fetching 311 cases" unless response.success?
    
    cases = JSON.parse(response.body)

    # filter out 311 cases that were requested before `since`
    cases.reject { |caze| Time.parse(caze['requested_datetime']).to_i < since }
  end
end
