require 'rails_helper'

RSpec.describe Case, type: :model do
  describe '#transform_and_bulk_insert_raw_cases' do
    before do
      Case.destroy_all
    end

    it 'transforms a raw case and inserts a valid record' do
      caze = JSON.parse(<<-JSON)
        {
          "status_description" : "Open",
          "address" : "278 HOLLADAY AVE, SAN FRANCISCO, CA, 94110",
          "service_name" : "Streetlights",
          "service_request_id" : "7421585",
          "source" : "Web Self Service",
          "status_notes" : "open",
          "supervisor_district" : "9",
          "long" : "-122.4055",
          "point" : {
            "latitude" : "37.745390932203",
            "longitude" : "-122.405541693853"
          },
          "agency_responsible" : "PUC Streetlights Queue",
          "service_subtype" : "Streetlight - Light_Burnt_Out",
          "service_details" : "Light_Burnt_Out on Unknown Pole",
          "neighborhoods_sffind_boundaries" : "Peralta Heights",
          "requested_datetime" : "2017-07-26T00:55:58",
          "updated_datetime" : "2017-07-26T00:55:58",
          "police_district" : "INGLESIDE",
          "lat" : "37.74539"
        }
      JSON

      Case.transform_and_bulk_insert_raw_cases([caze])

      expect(Case.all.count).to eq(1)

      saved_case = Case.find_by_service_request_id(7421585)

      expect(saved_case).to_not be_nil
      expect(saved_case.status).to eq("Open")
      expect(saved_case.category).to eq("Streetlights")
      
      location = saved_case.location

      expect(location.latitude).to eq(37.745390932203)
      expect(location.longitude).to eq(-122.405541693853)
    end
  end

end
