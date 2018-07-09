import() {
  local hash
  hash="$(echo "$1" | sha1sum | { read -r first rest; echo "$first"; })" || return
  local cache="${IMPORT_CACHE-${HOME}/.import-cache}"
  local cachefile="${cache}/${hash}"
  if [ ! -f "${cachefile}" ] || [ ! -z "${IMPORT_RELOAD-}" ]; then
    mkdir -p "${cache}" || return
    curl -fsSL --netrc-optional ${IMPORT_CURL_OPTS-} "$1" > "${cachefile}.tmp" || {
      r=$?
      rm "${cachefile}.tmp" || return
      return "$r"
    }
    mv "${cachefile}.tmp" "${cachefile}" || return
    [ ! -z "${IMPORT_DEBUG-}" ] && echo "imported: $1" >&2
  fi
  if [ -z "${print-}" ]; then
    source "${cachefile}" || return
  else
    echo "${cachefile}"
  fi
}
