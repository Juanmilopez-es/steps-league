# Procfile para Railway/Heroku/Render
# El proceso web ejecuta migraciones antes de iniciar el servidor

web: bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}
