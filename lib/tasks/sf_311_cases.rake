namespace :sf_311_cases do
  desc "Fetch new SF 311 cases created during the previous 24 hours"
  task fetch: :environment do
    time_of_last_case = Case.order("case_requested DESC").limit(1).pluck(:case_requested).first.to_i

    sfdata = SanFranciscoData.new
    cases = sfdata.fetch_311_cases(time_of_last_case + 1)  # New records were created at least 1 second after the most recent

    puts "Trying to insert #{cases.count} 311 cases...\n"

    Case.transform_and_bulk_insert_raw_cases(cases)
  end
end
