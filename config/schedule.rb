# Learn more: http://github.com/javan/whenever

# Note: new data is probably not available from SF Data on weekends
every 1.day, :at => '12:00 am' do
  rake 'sf_311_cases:fetch' 
end
