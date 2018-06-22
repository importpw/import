# [import.pw](https://import.pw)

URL `import` function for bash scripts with caching.

#### Dependencies

 * `awk`
 * `curl`
 * `sha1sum`

# Example

```bash
#!/bin/bash
set -euo pipefail

# Bootstrap the `import` function (there are multiple ways to do this)
source "`which import.sh`"

# This gets downloaded once, cached forever, and then `source`d into your script
import "gh.import.pw/tootallnate/chalk@1.0.0"

echo "`chalk.blue Hello` World`chalk.red '!'`"
```
