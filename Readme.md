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
