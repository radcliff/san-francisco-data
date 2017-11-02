Time.zone = 'Pacific Time (US & Canada)'

json.service_request_id caze.service_request_id
json.category           caze.category
json.service_subtype    caze.service_subtype
json.service_details    caze.service_details
json.status             caze.status
json.agency             caze.agency
json.address            caze.address

json.location do
  json.type "Point"
  json.coordinates [caze.location.longitude, caze.location.latitude]
end

json.case_requested     Time.at(caze.case_requested).iso8601
json.case_updated       Time.at(caze.case_updated).iso8601
json.source             caze.source
