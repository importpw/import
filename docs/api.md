## 📜 API

### `import "$url"`

The core `import` function downloads the `$url` parameter and
[caches](./caching.md) it to the file system. Finally, it sources
the downloaded script.

```bash
#!/usr/bin/env import
import "https://import.sh/string@0.2.0"

echo InPuT | string_upper
# INPUT
```


### `import_file "$url"`

Uses the same download and caching infrastructure as `import`, but prints the
local file path instead of sourcing the file. This enables working with arbitrary
files such as scripts from other languages, simple data files, binary files, etc.

```bash
#!/usr/bin/env import

ruby "$(import_file https://import.sh/importpw/import/test/static/sum.rb)" 9 10 11 12
# 42
```


### `import_cache_dir "$name"`

Returns the operating system specific path to the cache directory for the given
`$name`. This function honors the [XDG Base Directory
Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
by utilizing the `$XDG_CACHE_HOME` environment variable, if defined. Otherwise it
falls back to using:

 * `$HOME/Library/Caches` on macOS
 * `$LOCALAPPDATA` on Windows
 * `$HOME/.cache` everywhere else

```bash
#!/usr/bin/env import

import_cache_dir example
# /Users/nate/Library/Caches/example

XDG_CACHE_HOME=/cache import_cache_dir example
# /cache/example
```


### `import_cache_dir_import`

Returns the operating system specific path to the cache directory that files
imported using `import` are written to. This function returns the contents the
`$IMPORT_CACHE` environment variable, if defined. Otherwise it returns the result
of `import_cache_dir import.sh`.

```bash
#!/usr/bin/env import

import_cache_dir_import
# /Users/nate/Library/Caches/import.sh

IMPORT_CACHE=/tmp import_cache_dir_import
# /tmp
```
