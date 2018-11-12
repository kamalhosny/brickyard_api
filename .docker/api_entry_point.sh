bundle check || bundle install

bin/rake db:create db:migrate db:seed

bin/rails s -b 0.0.0.0 -p 3000
