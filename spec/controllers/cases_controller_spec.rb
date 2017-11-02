require 'rails_helper'

RSpec.describe CasesController, type: :controller do
  render_views

  describe "GET #index" do
    # GET /cases.json
    it 'returns all cases' do
      get 'index', format: 'json'
      expect(response).to have_http_status(:success)

      cases = JSON.parse(response.body)

      expect(cases).to be_an_instance_of(Array)
      expect(cases.count).to eq(Case.all.count)
    end


    # GET /cases.json?since=1398465719
    it 'returns cases opened since UNIX timestamp' do
      since_timestamp = '1501052399'

      get 'index', format: 'json', params: { since: since_timestamp }
      expect(response).to have_http_status(:success)
      
      cases = JSON.parse(response.body)
      expect(cases.count).to eq(918)

      # select cases that are not older than the `since` param
      # .select do |caze|
      #   caze['case_requested'] > since_timestamp
      # end

      # expect(cases.count).to eq(0)
    end

    # GET /cases.json?status=open
    it 'returns cases that are in specified state' do
      status = 'open'

      get 'index', format: 'json', params: { status: status }
      expect(response).to have_http_status(:success)

      # select cases that do not have status open
      cases = JSON.parse(response.body).select do |caze|
        caze['status'].downcase != status
      end

      expect(cases.count).to eq(0)
    end


    # GET /cases.json?category=General%20Requests
    it 'returns cases that belong to specified category' do
      category = 'General Requests'

      get 'index', format: 'json', params: { category: category }
      expect(response).to have_http_status(:success)

      # filter out cases that belong to specified category
      cases = JSON.parse(response.body).reject do |caze|
        caze['category'].downcase.strip.include?(category)
      end

      expect(cases.count).to eq(0)
    end

    # GET /cases.json?near=37.77,-122.48
    it 'returns cases that were created within 5 mile radius of `near` coordinate' do
      near_coordinate = [37.77,-122.48]
      clf = Case::LOCATION_FACTORY

      get 'index', format: 'json', params: { near: near_coordinate.join(',') }
      expect(response).to have_http_status(:success)

      # select cases that are nearby
      near_point = clf.point(*near_coordinate.reverse)

      cases = JSON.parse(response.body).select do |caze|
        longitude, latitude = caze.dig("location", "coordinates")
        case_point = clf.point(longitude, latitude)
        near_point.distance(case_point) <= 8050
      end

      expect(Case.all.count).to be > cases.count  # there should be some cases outside 5 mi. radius
      expect(cases.count).to eq(830)  # via test data (see: db/seeds.rb)
    end

    # GET /cases.json?near=37.77,-122.48&status=open&category=General%20Requests
    it 'should be able to take any combination of GET params' do
      since_timestamp = '1501052400'
      status = 'open'
      category = 'Homeless Concerns'
      near_coordinate = [37.77,-122.48]

      get 'index', format: 'json', params: {
        since: since_timestamp,
        status: status,
        category: category,
        near: near_coordinate.join(',')
      }

      expect(response).to have_http_status(:success)

      cases = JSON.parse(response.body)
      expect(cases.count).to eq(40)

      caze = cases.last

      expect(caze['case_requested']).to be > since_timestamp
      expect(caze['status'].downcase).to eq(status.downcase)
      expect(caze['category'].downcase.include?(category.downcase)).to be true
    end
  end

end
