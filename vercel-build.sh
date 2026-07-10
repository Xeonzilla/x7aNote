#!/usr/bin/env bash
set -euo pipefail

hugo_args=(
  --environment production
  --panicOnWarning
  --printI18nWarnings
  --printPathWarnings
  --printUnusedTemplates
  --minify
)

check_hugo_version() {
  local current
  local latest
  local latest_url

  current="$(
    hugo version 2>/dev/null \
      | grep -Eo 'v?[0-9]+(\.[0-9]+){2}' \
      | head -n 1 \
      | sed 's/^v//' \
      || true
  )"

  if ! command -v curl >/dev/null 2>&1; then
    echo "Hugo version check skipped: curl is unavailable."
    return 0
  fi

  latest_url="$(
    curl -fsSI --connect-timeout 3 --max-time 5 -o /dev/null -w '%{redirect_url}' \
      'https://github.com/gohugoio/hugo/releases/latest' \
      2>/dev/null \
      || true
  )"
  latest_url="${latest_url%/}"
  latest="${latest_url##*/}"
  latest="${latest#v}"

  if [[ -z "$current" || -z "$latest" || "$latest" == "latest" ]]; then
    echo "Hugo version check skipped: unable to determine current or latest Hugo version."
    return 0
  fi

  if [[ "$current" != "$latest" ]]; then
    echo "Hugo version notice: Vercel is using Hugo ${current}, while the latest release is ${latest}."
  else
    echo "Hugo version check: Vercel is using the latest Hugo release (${current})."
  fi
}

check_hugo_version &
version_check_pid=$!

build_status=0
hugo "${hugo_args[@]}" || build_status=$?

wait "$version_check_pid" || true

if ((build_status != 0)); then
  exit "$build_status"
fi

mkdir -p .vercel_build_output/config

cat > .vercel_build_output/config/build.json <<'JSON'
{
  "cache": [
    "resources/_gen/**"
  ]
}
JSON
