#!/bin/sh

# Only `shasum  is present on MacOS by default,
# but only `sha1sum` is present on Alpine by default
__import_shasum="$(which sha1sum)" || __import_shasum="$(which shasum)" || {
  r=$?
  echo "import: no \`shasum\` or \`sha1sum\` command present" >&2
  rm "$tmpfile" || return
  exit "$r"
}
[ -n "${IMPORT_DEBUG-}" ] && echo "import: using '$__import_shasum'" >&2

import() {
  local url="$1"
  [ -n "${IMPORT_DEBUG-}" ] && echo "import: importing '$url'" >&2

  # The base directory for the import cache.
  # Defaults to `$HOME/.import_cache`.
  # May be configured by setting the `IMPORT_CACHE` variable.
  local cache="${IMPORT_CACHE-${HOME}/.import-cache}"

  # Apply the default server if the user is doing an implicit import
  if ! echo "$url" | grep "://" > /dev/null && ! echo "$url" | awk -F/ '{print $1}' | grep '\.' > /dev/null; then
    url="${IMPORT_SERVER-import.pw}/$url"
  fi

  if [ ! -e "$cache/$url" ] || [ -n "${IMPORT_RELOAD-}" ]; then
    # Ensure that the directory containing the symlink for this import exists.
    local link_dir
    link_dir="$cache/$(dirname "$url")"
    mkdir -p${IMPORT_DEBUG+v} "$link_dir" >&2 || return

    # Resolve the cache and link dirs with `pwd` now that the directories exist.
    cache="$( ( cd "$cache" && pwd ) )" || return
    link_dir="$( ( cd "$link_dir" && pwd ) )" || return

    # Download the requested file to a temporary place so that the shasum
    # can be computed to determine the proper final filename.
    local tmpfile="$cache/$url.tmp"
    curl -fsSL --netrc-optional ${IMPORT_CURL_OPTS-} "$url" > "$tmpfile" || {
      r=$?
      echo "import: failed to download: $url" >&2
      rm "$tmpfile" || return
      return "$r"
    }

    # Calculate the sha1 hash of the contents of the downloaded file.
    local hash
    hash="$("$__import_shasum" < "$tmpfile" | { read -r first rest; echo "$first"; })" || return
    [ -n "${IMPORT_DEBUG-}" ] && echo "import: calculated hash '$url' -> '$hash'" >&2

    # If the hashed file doesn't exist then move it into place,
    # otherwise delete the temp file - it's no longer needed.
    if [ -f "$cache/$hash" ]; then
      rm "$tmpfile" || return
    else
      mv "$tmpfile" "$cache/$hash" || return
    fi

    # Create a relative symlink for this import pointing to the hashed file.
    local relative
    local cache_start
    cache_start="$(expr "${#cache}" + 1)"
    relative="$(echo "$link_dir" | awk '{print substr($0,'$cache_start')}' | sed 's/\/[^/]*/..\//g')$hash" || return
    [ -n "${IMPORT_DEBUG-}" ] && printf "import: creating symlink " >&2
    ln -fs${IMPORT_DEBUG+v} "$relative" "$cache/$url" >&2 || return

    [ -n "${IMPORT_DEBUG-}" ] && echo "import: successfully imported '$url' -> '$cache/$hash'" >&2
  fi

  # Reset the `import` command args. There's not really a good reason to pass
  # the URL to the sourced script, and in fact could cause undesirable results.
  # i.e. This is required to make `import.pw/kward/shunit2` work out of the box.
  set --

  # At this point, the file has been saved to the cache so
  # either source it or print it.
  if [ -z "${print-}" ]; then
    . "$cache/$url" || return
  else
    echo "$cache/$url"
  fi
}


# For `#!/usr/bin/env import`
if [ -n "${ZSH_EVAL_CONTEXT-}" ]; then
  if [ "${ZSH_EVAL_CONTEXT-}" = "toplevel" ]; then
    __import_entrypoint="$1"
    shift
    . "$__import_entrypoint"
  fi
elif [ "$(basename "$0" .sh)" = "import" ]; then
  __import_entrypoint="$1"
  shift
  . "$__import_entrypoint"
fi
