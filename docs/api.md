## 📜 API

### `import "$url"`

The core `import` function downloads the `$url` parameter and
[caches](./caching.md) it to the file system. Finally, it sources
the downloaded script.

```bash
#!/usr/bin/env import
import "https://import.pw/string@0.2.0"

echo InPuT | string_upper
# INPUT
```
