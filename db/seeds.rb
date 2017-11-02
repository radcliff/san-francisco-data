puts "Loading seed data from 'db/cases.json' ...\n"

raw_json = File.read(File.join(__dir__, 'cases.json'))
cases = JSON.parse(raw_json)

puts "Trying to insert #{cases.count} 311 cases...\n"

Case.transform_and_bulk_insert_raw_cases(cases)
