# 💸 Caching

Caching is a core concept in `import`. Scripts are downloaded _exactly once_, and
then cached on your filesystem _forever_ (or if the `IMPORT_RELOAD=1` env var is
set).

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
import: normalized URL 'https://import.pw/assert'
import: end of headers 'https://import.pw/assert'
import: resolved location 'https://import.pw/assert' -> 'https://raw.githubusercontent.com/importpw/assert/master/assert.sh'
import: calculated hash 'https://import.pw/assert' -> 'bf671d3752778f91ad0884ff81b3e963af9e4a4f'
import: creating symlink '/tmp/links/https://import.pw/assert' -> '../../../data/bf671d3752778f91ad0884ff81b3e963af9e4a4f'
import: successfully imported 'https://import.pw/assert' -> '/tmp/data/bf671d3752778f91ad0884ff81b3e963af9e4a4f'
```

Now let's take a look at what the actual directory structure looks like:

```
$ tree /tmp
/tmp
├── data
│   └── bf671d3752778f91ad0884ff81b3e963af9e4a4f
├── links
│   └── https:
│       └── import.pw
│           └── assert -> ../../../data/bf671d3752778f91ad0884ff81b3e963af9e4a4f
└── locations
    └── https:
        └── import.pw
            └── assert
```

`import` generates **three** subdirectories under the `IMPORT_CACHE` directory:

 * `data` - The raw shell scripts, named after the sha1sum of the file contents
 * `links` - Symbolic links that are named according to the import URL
 * `locations` - Files named according to the import URL that point to the _real_ URL
