#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-3000}"

# The app already has a production config; we use it by default.
RAILS_ENV="${RAILS_ENV:-production}"

DB_HOST="${DB_HOST:-pcdelphine}"
DB_USER="${DB_USER:-evedata}"
DB_PASSWORD="${DB_PASSWORD:-evedata}"

echo "==> Waiting for MySQL (${DB_HOST})..."
for i in $(seq 1 60); do
  if mysqladmin ping -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASSWORD}" --silent >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

echo "==> Running database migrations..."
bundle exec rails db:migrate

echo "==> Precompiling assets..."
bundle exec rails assets:precompile

echo "==> Starting Puma..."
exec bundle exec puma -C config/puma.rb -b "tcp://0.0.0.0:${PORT}"

