import() {
  local hash
  hash="$(echo "$1" | sha1sum | { read -r first rest; echo "$first"; })" || exit
  local cache="${IMPORT_CACHE-${HOME}/.import-cache}"
  local cachefile="${cache}/${hash}"
  if [ ! -f "${cachefile}" ] || [ ! -z "${IMPORT_RELOAD-}" ]; then
    mkdir -p "${cache}" || exit
    curl -fsSL --netrc-optional ${IMPORT_CURL_OPTS-} "$1" > "${cachefile}.tmp" || exit
    mv "${cachefile}.tmp" "${cachefile}" || exit
    [ ! -z "${IMPORT_DEBUG-}" ] && echo "imported: $1" >&2
  fi
  if [ -z "${print-}" ]; then
    source "${cachefile}" || exit
  else
    echo "${cachefile}"
  fi
}
