class Case < ActiveRecord::Base
  LOCATION_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  SAN_FRANCISCO_TIMEZONE = ActiveSupport::TimeZone["Pacific Time (US & Canada)"]

  scope :requested_since, ->(since) { where('case_requested > to_timestamp(?)', since) }
  scope :status, ->(status) { where('lower(status) = ?', status.downcase) }
  scope :category, ->(category) { where('lower(category) LIKE ?', "%#{category.downcase}%") }
  scope :nearby, -> (latitude, longitude, distance_in_meters = 8050) {
    where("ST_Distance(location, ?) < ?", "POINT(#{longitude} #{latitude})", distance_in_meters)
  }

  def self.transform_and_bulk_insert_raw_cases(cases)
    transformed_cases = cases.reduce([]) do |memo, caze|
      longitude  = caze.dig("point", "longitude")
      latitude   = caze.dig("point", "latitude")

      if longitude && latitude
        case_requested = SAN_FRANCISCO_TIMEZONE.parse(caze['requested_datetime']).utc
        case_updated   = SAN_FRANCISCO_TIMEZONE.parse(caze['updated_datetime']).utc

        memo << {
          'service_request_id' => caze['service_request_id'],
          'category'           => caze['service_name'],
          'service_subtype'    => caze['service_subtype'],
          'service_details'    => caze['service_details'],
          'status'             => caze['status_description'],
          'status_notes'       => caze['status_notes'],
          'agency'             => caze['agency_responsible'],
          'address'            => caze['address'],
          'location'           => "POINT(#{longitude} #{latitude})",
          'case_requested'     => case_requested,
          'case_updated'       => case_updated,
          'source'             => caze['source']
        }
      end

      memo
    end

    Case.bulk_insert(values: transformed_cases, ignore: true)
  end
end
