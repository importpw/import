#!/bin/bash
IMPORT_PATH="${HOME}/.import-cache"

import() {
  local url="$1"
  local hash="$(printf "%s" "${url}" | sha1sum | awk '{print $1}')"
  local cachefile="${IMPORT_PATH}/${hash}"
  if [ ! -f "${cachefile}" ] || [ ! -z "${IMPORT_RELOAD-}" ]; then
    mkdir -p "${IMPORT_PATH}"
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