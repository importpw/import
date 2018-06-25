#!/bin/bash
IMPORT_CACHE="${HOME}/.import-cache"

import() {
  local url="$1"
  local hash="$(echo "${url}" | sha1sum | { read first rest; echo $first; })"
  local cachefile="${IMPORT_CACHE}/${hash}"
  if [ ! -f "${cachefile}" ] || [ ! -z "${IMPORT_RELOAD-}" ]; then
    mkdir -p "${IMPORT_CACHE}"
    local r=0
    (echo "# ${url}" && curl "${url}" -sSL --fail) > "${cachefile}.tmp" || r=$?
    if [ "$r" -ne 0 ]; then
      echo "Import failed: $r $url" >&2
      return "$r"
    fi
    mv "${cachefile}.tmp" "${cachefile}"
    [ ! -z "${IMPORT_DEBUG-}" ] && echo "Imported: ${url}" >&2
  fi
  source "${cachefile}"
}
