# [import.pw](https://import.pw)

URL `import` function for bash scripts with caching.

Inspired by Go's import command, you specify the URI of the bash script,
and the `import` function downloads it and caches it to `~/.import-cache`
(by default) _forever_. This way, the code will never change from below
your feet and it will work offline / on an airplane.

### Dependencies

 * `curl`
 * `sha1sum`


## Example

The URL https://git.io/f4SOX contains a simple `add()` bash function.
You can use the `import` function to download, cache, and use that function.

```bash
#!/bin/bash
set -euo pipefail

# Bootstrap the `import` function (there are multiple ways to do this)
eval "`curl -sfLS import.pw`"

# This gets downloaded once, cached forever, and then `source`d into your script
import "git.io/f4SOX"

add 7 11
# 18
```


## Bootstrapping the `import.sh` script

Since the `import.sh` file itself defines the `import()` function, you naturally
can not use the `import` function to load the import function.

The "quick and pretty" way it to simply `curl` + `eval` the import script, as in
the Example above:

```bash
eval "`curl -sfLS import.pw`"
```

However, this involves an HTTP request every time that the bash script is run, and
thus would not work offine and is not as optimized.

A more robust solution is to first attempt to load the import script from the
filesystem, and then fall back to the network request if the local file does not
exist. For example:

```bash
while IFS=: read -d: -r p; do [ -f "$p/import.sh" ] && source "$p/import.sh" && break ||:
done <<< "${IMPORT_PATH:+"$IMPORT_PATH:"}$HOME/lib:/usr/lib:/usr/local/lib:"
declare -f import >/dev/null || eval "`curl -sfLS import.pw`"
```

This code snippet attempts to load the `import.sh` file from:

 * `$IMPORT_PATH` (`:` separated directory paths)
 * `$HOME/lib/import.sh`
 * `/usr/lib/import.sh`
 * `/usr/local/lib/import.sh`

And if it does not exist in these paths then the `eval` example above is used.


## Caching the `import.sh` script locally

To utilize the robust bootstrapping code, you will need to have the `import.sh`
script cached locally. For example, to install it to `/usr/local/lib`:

```bash
curl -sfLS import.pw > /usr/local/lib/import.sh
```

After that, scripts that use the robust bootstrapping code will load _very fast_,
since no network operations are involved.
