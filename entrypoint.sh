# Gem install
bundle check || bundle install

# creating a database and migrations
bundle exec rails db:create db:migrate

# running the server
rm -f tmp/pids/server.pid && bundle exec rails s -p 3001 -b '0.0.0.0'
