import() {
  [ -n "${IMPORT_DEBUG-}" ] && echo "import: importing '$1'" >&2

  # The base directory for the import cache.
  # Defaults to `$HOME/.import_cache`.
  # May be configured by setting the `IMPORT_CACHE` variable.
  local cache="${IMPORT_CACHE-${HOME}/.import-cache}"

  if [ ! -e "$cache/$1" ] || [ -n "${IMPORT_RELOAD-}" ]; then
    # Ensure that the directory containing the symlink for this import exists.
    local link_dir
    link_dir="$cache/$(dirname "$1")"
    mkdir -p${IMPORT_DEBUG+v} "$link_dir" >&2 || return

    # Resolve the cache and link dirs with `pwd` now that the directories exist.
    cache="$( ( cd "$cache" && pwd ) )" || return
    link_dir="$( ( cd "$link_dir" && pwd ) )" || return

    # Download the requested file to a temporary place so that the shasum
    # can be computed to determine the proper final filename.
    local tmpfile="$cache/$1.tmp"
    curl -fsSL --netrc-optional ${IMPORT_CURL_OPTS-} "$1" > "$tmpfile" || {
      r=$?
      echo "import: failed to download: $1" >&2
      rm "$tmpfile" || return
      return "$r"
    }

    # Calculate the sha1 hash of the contents of the downloaded file.
    local hash
    hash="$(sha1sum < "$tmpfile" | { read -r first rest; echo "$first"; })" || return
    [ -n "${IMPORT_DEBUG-}" ] && echo "import: calculated hash '$1' -> '$hash'" >&2

    # If the hashed file doesn't exist then move it into place,
    # otherwise delete the temp file - it's no longer needed.
    if [ -f "$cache/$hash" ]; then
      rm "$tmpfile" || return
    else
      mv "$tmpfile" "$cache/$hash" || return
    fi

    # Create a relative symlink for this import pointing to the hashed file.
    local relative
    relative="$(echo "${link_dir:${#cache}}" | sed 's/\/[^/]*/..\//g')$hash" || return
    [ -n "${IMPORT_DEBUG-}" ] && printf "import: creating symlink " >&2
    ln -fs${IMPORT_DEBUG+v} "$relative" "$cache/$1" >&2 || return

    [ -n "${IMPORT_DEBUG-}" ] && echo "import: successfully imported '$1' -> '$cache/$hash'" >&2
  fi

  # At this point, the file has been saved to the cache so
  # either source it or print it.
  if [ -z "${print-}" ]; then
    source "$cache/$1" || return
  else
    echo "$cache/$1"
  fi
}
