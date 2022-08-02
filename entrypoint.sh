#!/bin/bash

# remove any pid file for the server that was created before
rm -f /chat-system/tmp/pids/server.pid

# wait for each of the services to start
/usr/bin/wait-for-it.sh db:3306 -t 0
/usr/bin/wait-for-it.sh redis:6379 -t 0
/usr/bin/wait-for-it.sh elasticsearch:9200 -t 0

# run sidekiq in the background
cd chat-system
bundle exec sidekiq &

# create, migrate and seed the mysql database
rails db:create db:migrate db:seed

# execute the container's main process
exec "$@"
