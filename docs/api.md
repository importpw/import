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

### `import_file "$url"`

The `import_file` functions uses the same download & cache infrastructure as
`import` but prints the local path instead of sourcing the file. This supports
working with arbitrary files including scripts in other languages and simple
data files.
```bash
#!/usr/bin/env import
ruby "$(import_file https://import.pw/importpw/import/test/static/sum.rb)" 9 10 11 12
# 42
```
