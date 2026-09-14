#!/usr/bin/env bash
set -euo pipefail

check_hugo_version() {
  local current=""
  local latest

  if [[ "$(hugo version 2>/dev/null || true)" =~ v?([0-9]+(\.[0-9]+){2}) ]]; then
    current="${BASH_REMATCH[1]}"
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "Hugo version check skipped: curl is unavailable."
    return 0
  fi

  latest="$(
    curl -fsSI --connect-timeout 3 --max-time 5 -o /dev/null -w '%{redirect_url}' \
      'https://github.com/gohugoio/hugo/releases/latest' \
      2>/dev/null \
      || true
  )"
  latest="${latest%/}"
  latest="${latest##*/}"
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

# Hugo's official Vercel recipe keeps file caches under HUGO_CACHEDIR (https://gohugo.io/host-and-deploy/host-on-vercel/).
export HUGO_CACHEDIR="${PWD}/.vercel/cache/hugo"

HUGO_ARTICLE_WORD_COUNT=1 hugo \
  --environment production \
  --panicOnWarning \
  --printI18nWarnings \
  --printPathWarnings \
  --printUnusedTemplates \
  --minify || {
  build_status=$?
  wait "$version_check_pid" || true
  exit "$build_status"
}

report="$(cat public/article-word-count.txt)"
rm -- public/article-word-count.txt
printf '%s\n' "$report"

wait "$version_check_pid" || true
