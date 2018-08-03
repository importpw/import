# [import.pw](https://import.pw)

URL `import` function for shell scripts with caching.

Inspired by Go's import command, you specify the URI of the shell script,
and the `import` function downloads it and caches it to `~/.import-cache`
(by default) _forever_. This way, the code will never change from below
your feet and it will work offline / on an airplane.

### Dependencies

 * `curl`
 * `sha1sum`


## 👋 Example

This gist (https://git.io/f4SOX) contains a simple `add()` shell function:

```bash
add() {
  echo "$(( $1 + $2 ))"
}
```

You can use the `import` function to download, cache, and use that function in
your own script:

```bash
#!/bin/sh

# Bootstrap the `import` function
eval "`curl -sfLS import.pw`"

# The gist is downloaded once, cached forever, and then `source`d into your script
import "git.io/f4SOX"

add 7 11
# 18
```


## 🔑 Authentication

Because `import` uses `curl`, you can use the standard [`.netrc` file
format](https://ec.haxx.se/usingcurl-netrc.html) to define your username
and passwords to the server you are importing from.

For exampe, to make script files in private GitHub repos accessible, create a
`~/.netrc` file that contains something like:

```
machine raw.githubusercontent.com
login 231a4602aeb1fbcf164f7c444ae5a211c1451d95
password x-oauth-basic
```

The `login` token is a [GitHub "personal access token"](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
Follow the instructions in that link to create one for yourself.

After that, an `import` call to a private repo will work as expected:

```
import "import.pw/my-private-org/repo@1.0.0"
```

Your GitHub credentials **ARE NEVER** given to the `import.pw` server.
They are only used _locally_ by `curl` once import.pw redirects to the
private repo URL.


## 🐔🥚 Bootstrapping the `import.sh` script

Since the `import.sh` file itself defines the `import()` function, you naturally
can not _use_ the `import` function to load the import script. This is a classic
chicken vs. egg problem!

The "quick and dirty" way is to simply `curl` + `eval` the import script:

```bash
eval "`curl -sfLS import.pw`"
```

However, this involves an HTTP request every time that the shell script is run,
and thus would not work offine and is not as optimized.

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

If the `import.sh` script is not cached in any of those paths, then the
`curl` + `eval` fallback is used.


## Caching the `import.sh` script locally

To utilize the robust bootstrapping code, you will need to have the `import.sh`
script cached locally. For example, to install it to `/usr/local/lib`:

```bash
curl -sfLS import.pw > /usr/local/lib/import.sh
```

After that, scripts that use the robust bootstrapping code will load _very fast_,
since no network operations are involved.
