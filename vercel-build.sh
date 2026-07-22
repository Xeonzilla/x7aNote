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

if ((build_status != 0)); then
  wait "$version_check_pid" || true
  exit "$build_status"
fi

# Re-render article content only; the production build above already validates public outputs and remote resources.
if ! (
  temp_dir="$(mktemp -d .article-word-count.XXXXXX)" || exit 1
  trap 'rm -rf -- "$temp_dir"' EXIT

  cp -R layouts "$temp_dir/layouts" || exit 1

  cat > "$temp_dir/hugo.toml" <<'TOML' || exit 1
[outputFormats.article_word_count]
mediaType = "text/plain"
baseName = "article-word-count"
isPlainText = true
notAlternative = true

[outputs]
home = ["html", "feed", "article_word_count"]

[[cascade]]
outputs = ["html"]

[cascade.target]
kind = "page"
path = "/posts/**"
TOML

  cat > "$temp_dir/layouts/home.article_word_count.txt" <<'GOTMPL' || exit 1
{{- $posts := where site.RegularPages "Section" "posts" -}}
{{- $wordCount := 0 -}}
{{- range $posts -}}
	{{- $wordCount = add $wordCount .WordCount -}}
{{- end -}}
{{- fmt.Warnf "Article word count: %d words across %d articles." $wordCount (len $posts) -}}
GOTMPL

  cat > "$temp_dir/layouts/home.html" <<'GOTMPL' || exit 1
{{- "" -}}
GOTMPL

  cat > "$temp_dir/layouts/home.feed.xml" <<'GOTMPL' || exit 1
{{- "" -}}
GOTMPL

  cat > "$temp_dir/layouts/posts/page.html" <<'GOTMPL' || exit 1
{{- .Content -}}
GOTMPL

  cat > "$temp_dir/layouts/_partials/render-image/publish.html" <<'GOTMPL' || exit 1
{{- /* Image metadata and URLs do not contribute to Hugo's stripped-content word count. */ -}}
{{- return (dict "RelPermalink" "" "Width" 1 "Height" 1) -}}
GOTMPL

  if ! hugo \
    --config "hugo.toml,$temp_dir/hugo.toml" \
    --environment production \
    --layoutDir "$temp_dir/layouts" \
    --renderToMemory \
    > "$temp_dir/hugo.log" 2>&1
  then
    cat "$temp_dir/hugo.log" >&2
    exit 1
  fi

  grep -m 1 '^WARN  Article word count: ' "$temp_dir/hugo.log" | sed 's/^WARN  //' || exit 1
); then
  echo "Article word count skipped: unable to generate the report."
fi

wait "$version_check_pid" || true

mkdir -p .vercel_build_output/config

cat > .vercel_build_output/config/build.json <<'JSON'
{
  "cache": [
    "resources/_gen/**"
  ]
}
JSON
