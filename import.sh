#!/bin/sh

# Only `shasum` is present on MacOS by default,
# but only `sha1sum` is present on Alpine by default
__import_shasum="$(command -v sha1sum)" || __import_shasum="$(command -v shasum)" || {
	r=$?
	echo "import: no \`shasum\` or \`sha1sum\` command present" >&2
	exit "$r"
}
[ -n "${IMPORT_DEBUG-}" ] && echo "import: using '$__import_shasum'" >&2

import_parse_location() {
	local location="$1"
	local is_redirect=0
	while IFS='' read -r line; do
		# Strip trailing CR
		line="$(printf "%s" "$line" | tr -d \\r)"
		if [ -z "$line" ]; then
			if [ "$is_redirect" -eq 0 ]; then
				# End of headers
				break
			else
				# This is the end of redirect, and it is expected that more
				# headers are coming, so continue parsing the headers
				is_redirect=0
			fi
		elif echo "$line" | grep -i '^location:' >/dev/null; then
			is_redirect=1
			location="$(echo "$line" | awk -F": " '{print $2}')"
		elif echo "$line" | grep -i '^content-location:' >/dev/null; then
			location="$(echo "$line" | awk -F": " '{print $2}')"
		elif echo "$line" | grep -i '^x-import-warning:' >/dev/null; then
			echo "import: warning - $(echo "$line" | awk -F": " '{print $2}')" >&2
		fi
	done
	echo "$location"
}

import() {
	local url="$*"
	local url_path
	[ -n "${IMPORT_DEBUG-}" ] && echo "import: importing '$url'" >&2

	# If this is a relative import than it need to be based off of
	# the parent import's resolved URL location.
	case "$url" in
		(./*) url="$(dirname "$__import_location")/$url";;
		(../*) url="$(dirname "$__import_location")/$url";;
	esac

	# The base directory for the import cache.
	# Defaults to `$HOME/.import_cache`.
	# May be configured by setting the `IMPORT_CACHE` variable.
	local cache="${IMPORT_CACHE-${HOME}/.import-cache}"

	# Apply the default server if the user is doing an implicit import
	if ! echo "$url" | grep "://" > /dev/null && ! echo "$url" | awk -F/ '{print $1}' | awk -F@ '{print $1}' | grep '\.' > /dev/null; then
		url="${IMPORT_SERVER-https://import.pw}/$url"
		[ -n "${IMPORT_DEBUG-}" ] && echo "import: normalized URL '$url'" >&2
	fi

	url_path="$(echo "$url" | sed 's/\:\///')"
	local cache_path="$cache/links/$url_path"

	if [ ! -e "$cache_path" ] || [ -n "${IMPORT_RELOAD-}" ]; then
		# Ensure that the directory containing the symlink for this import exists.
		local dir
		dir="$(dirname "$url_path")"

		local link_dir="$cache/links/$dir"
		mkdir -p "$link_dir" "$cache/data" "$cache/locations/$dir" >&2 || return

		# Resolve the cache and link dirs with `pwd` now that the directories exist.
		cache="$( ( cd "$cache" && pwd ) )" || return
		link_dir="$( ( cd "$link_dir" && pwd ) )" || return
		cache_path="$cache/links/$url_path"

		# Download the requested file to a temporary place so that the shasum
		# can be computed to determine the proper final filename.
		local location=""
		local tmpfile="$cache_path.tmp"
		local tmpheader="$cache_path.header"
		local locfile="$cache/locations/$url_path"
		local qs="?"
		if echo "$url" | grep '\?' > /dev/null; then
			qs="&"
		fi
		local url_with_qs="${url}${qs}format=raw"
		[ -n "${IMPORT_DEBUG-}" ] && echo "import: HTTP GET $url_with_qs" >&2
		curl -sfLS \
			--netrc-optional \
			--dump-header "$tmpheader" \
			${IMPORT_CURL_OPTS-} \
			"$url_with_qs" > "$tmpfile" || {
				local r=$?
				echo "import: failed to download: $url_with_qs" >&2
				rm -f "$tmpfile" "$tmpheader" || true
				return "$r"
			}

		# Now that the HTTP request has been resolved, parse the "Location"
		location="$(import_parse_location "$url" < "$tmpheader")" || return
		[ -n "${IMPORT_DEBUG-}" ] && echo "import: resolved location '$url' -> '$location'" >&2
		echo "$location" > "$locfile"
		rm -f "$tmpheader"

		# Calculate the sha1 hash of the contents of the downloaded file.
		local hash
		hash="$("$__import_shasum" < "$tmpfile" | { read -r first rest; echo "$first"; })" || return
		[ -n "${IMPORT_DEBUG-}" ] && echo "import: calculated hash '$url' -> '$hash'" >&2

		local hash_file="$cache/data/$hash"

		# If the hashed file doesn't exist then move it into place,
		# otherwise delete the temp file - it's no longer needed.
		if [ -f "$hash_file" ]; then
			rm -f "$tmpfile" || return
		else
			mv "$tmpfile" "$hash_file" || return
		fi

		# Create a relative symlink for this import pointing to the hashed file.
		local relative
		local cache_start
		cache_start="$(expr "${#cache}" + 1)"
		relative="$(echo "$link_dir" | awk '{print substr($0,'$cache_start')}' | sed 's/\/[^/]*/..\//g')data/$hash" || return
		[ -n "${IMPORT_DEBUG-}" ] && printf "import: creating symlink " >&2
		ln -fs${IMPORT_DEBUG:+v} "$relative" "$cache_path" >&2 || return

		[ -n "${IMPORT_DEBUG-}" ] && echo "import: successfully downloaded '$url' -> '$hash_file'" >&2
	else
		[ -n "${IMPORT_DEBUG-}" ] && echo "import: already cached '$url'" >&2
	fi

	# Reset the `import` command args. There's not really a good reason to pass
	# the URL to the sourced script, and in fact could cause undesirable results.
	# i.e. This is required to make `import.pw/kward/shunit2` work out of the box.
	set --

	# At this point, the file has been saved to the cache so
	# either source it or print it.
	if [ -z "${print-}" ]; then
		[ -n "${IMPORT_DEBUG-}" ] && echo "import: sourcing '$cache_path'" >&2
		local __import_parent_location="${__import_location-}"
		__import_location="$(cat "$cache/locations/$url_path")"
		. "$cache_path" || return
		__import_location="$__import_parent_location"
	else
		[ -n "${IMPORT_DEBUG-}" ] && echo "import: printing '$cache_path'" >&2
		echo "$cache_path"
	fi
}


# For `#!/usr/bin/env import`
if [ -n "${ZSH_EVAL_CONTEXT-}" ]; then
	if [ "${ZSH_EVAL_CONTEXT-}" = "toplevel" ]; then
		__import_entrypoint="1"
	fi
elif [ "$(echo "$0" | cut -c1)" != "-" ] && [ "$(basename "$0" .sh)" = "import" ]; then
	__import_entrypoint="1"
fi

if [ -n "${__import_entrypoint-}" ]; then
	# Parse argv
	while [ $# -gt 0 ]; do
		case "$1" in
			-s=*|--shell=*) __import_shell="${1#*=}"; shift 1;;
			-s|--shell) __import_shell="$2"; shift 2;;
			-c) __import_command="$2"; shift 2;;
			-*) echo "import: unknown option $1" >&2 && exit 2;;
			*) break;;
		esac
	done

	if [ -n "${__import_shell-}" ]; then
		# If the script requested a specific shell, then relaunch using it
		exec "$__import_shell" "$0" "$@"
	elif [ -n "${__import_command-}" ]; then
		eval "$__import_command"
	else
		__import_entrypoint="$1"
		shift
		. "$__import_entrypoint"
		fi
	fi
