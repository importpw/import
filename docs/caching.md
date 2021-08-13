## 💸 Caching

Caching is a core concept in `import`. Scripts are downloaded _exactly once_, and
then cached on your filesystem _forever_ (unless the `IMPORT_RELOAD=1` environment
variable is set).

```bash
#!/usr/bin/env import

# Import script files to the `/tmp` directory
IMPORT_CACHE="/tmp"

# Log information related to `import` to stderr
IMPORT_DEBUG=1

# Force a fresh download of script files (like Shift + Reload in the browser)
IMPORT_RELOAD=1

import assert
```

If you run this example, then you can see the file structure and order of
operations because of the debug logging:

```
import: importing 'assert'
import: normalized URL 'https://import.sh/assert'
import: HTTP GET https://import.sh/assert
import: resolved location 'https://import.sh/assert' -> 'https://raw.githubusercontent.com/importpw/assert/master/assert.sh'
import: calculated hash 'https://import.sh/assert' -> '0a1c5188c768b3b150f1a8a104bb71a3fa160aad'
import: creating symlink ‘/tmp/links/https/import.sh/assert’ -> ‘../../../data/0a1c5188c768b3b150f1a8a104bb71a3fa160aad’
import: successfully downloaded 'https://import.sh/assert' -> '/tmp/data/0a1c5188c768b3b150f1a8a104bb71a3fa160aad'
import: sourcing '/tmp/links/https/import.sh/assert'
```

Now let's take a look at what the actual directory structure looks like:

```
$ tree /tmp
/tmp
├── data
│   └── bf671d3752778f91ad0884ff81b3e963af9e4a4f
├── links
│   └── https
│       └── import.sh
│           └── assert -> ../../../data/bf671d3752778f91ad0884ff81b3e963af9e4a4f
└── locations
    └── https
        └── import.sh
            └── assert
```

`import` generates **three** subdirectories under the `IMPORT_CACHE` directory:

 * `data` - The raw shell scripts, named after the sha1sum of the file contents
 * `links` - Symbolic links that are named according to the import URL
 * `locations` - Files named according to the import URL that point to the _real_ URL

### ⚙️ Cache Location

If the `IMPORT_CACHE` environment variable is not set, the cache location
defaults to the directory `import.sh` in the OS-specific user cache directory.
For this user cache directory `import` considers (in order):

* `$XDG_CACHE_HOME` ([usually](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) set on Linux)
* `$LOCALAPPDATA` (usually set on Windows)
* `$HOME/Library/Caches` on macOS and `$HOME/.cache` everywhere else
