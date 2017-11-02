Read new 311 data from the City of San Francisco and write it into Postgres.

## Setup

1. Fork this repository and checkout the code to your local development
environment.
2. `bundle install`
4. Run the Rake DB create and Migrate tasks:
```
  bin/rake db:create db:migrate
```
5. Set up Test database and seed test data:
```
rake db:setup RAILS_ENV=test --trace
rake db:seed RAILS_ENV=test --trace
```
6. Run RSpec to verify test suite is working:
```
  rspec
```
7. Add cron job for fetch new 311 cases to crontab
```
  whenever --update-crontab
```
