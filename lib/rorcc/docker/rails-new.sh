#!/usr/bin/env bash
# Runs INSIDE a throwaway ruby:3.3 container (not on the host).
# Generates a fresh Rails app in the mounted /output dir, then drops in the
# generic Docker dev assets. The framework (.ai/.cursor/AGENTS.md) is added
# afterwards on the host via install.sh.
set -euo pipefail

ASSETS="${ASSETS_DIR:-/assets}"

echo "==> rails-new (docker): output=$(pwd)"
if [[ -f Gemfile ]]; then
  echo "ERROR: a Gemfile already exists in $(pwd). Use an empty directory."
  exit 1
fi

apt-get update -qq
apt-get install -y -qq build-essential default-libmysqlclient-dev git curl ca-certificates
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y -qq nodejs

gem install rails bundler --no-document

echo "==> rails new . ${RAILS_NEW_ARGS:-}"
rails new . ${RAILS_NEW_ARGS:---database=mysql --css=tailwind --javascript=esbuild --skip-git}

echo "==> Adding generic Docker dev assets..."
cp "${ASSETS}/Dockerfile.dev" .
cp "${ASSETS}/docker-compose.yml" .
cp "${ASSETS}/.dockerignore" .
cp "${ASSETS}/database.yml" config/database.yml
mkdir -p bin
cp "${ASSETS}/docker-entrypoint.sh" bin/
chmod +x bin/docker-entrypoint.sh

echo "==> Rails bootstrap complete."
