web: bundle exec puma -C config/puma.rb
js: yarn build:js --watch
worker: bundle exec sidekiq -C config/sidekiq.yml
release: bundle exec rails db:migrate