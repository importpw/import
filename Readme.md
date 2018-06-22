# [import.pw](https://import.pw)

URL `import` function for bash scripts with caching.

### Dependencies

 * `awk`
 * `curl`
 * `sha1sum`

## Example

```bash
#!/bin/bash
set -euo pipefail

# Bootstrap the `import` function (there are multiple ways to do this)
eval "`curl -sfLS import.pw`"

# This gets downloaded once, cached forever, and then `source`d into your script
import "import.pw/http@1.0.0"

serve() {
  set_response_header "Content-Type" "text/plain"
  echo Hello World
}

http.create_server serve 3000
```
