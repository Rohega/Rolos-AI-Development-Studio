#!/usr/bin/env bash
# Ensure gems are installed, then run the given command via bundle exec.
set -euo pipefail

cd /app

if ! bundle check &>/dev/null; then
  echo "==> bundle install..."
  bundle install
fi

exec bundle exec "$@"
