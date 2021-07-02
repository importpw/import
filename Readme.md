# import

`import` is a simple and fast module system for Bash and other Unix shells.

Inspired by Go's import command, you specify the URL of the shell script,
and the `import` function downloads the file and caches it locally, _forever_.

The code will never change from below your feet, and will continue to work
offline.


## 👋 Example

https://git.io/fAWiz ← This URL contains a simple `add` shell function:

```bash
add() {
  expr "$1" + "$2"
}
```

You can use the `import` function to download, cache, and use that function in
your own script:

```bash
#!/usr/bin/env import

# The URL is downloaded once, cached forever, and then sourced
import "https://git.io/fAWiz"

add 20 22
# 42
```


## ⚙️ Compatibility

The core `import` function is fully POSIX-compliant, and maximum compatibility
is the goal. `import` is unit tested against the following shell implementations:

 * [ash](https://en.wikipedia.org/wiki/Almquist_shell) - Almquist Shell (BusyBox `ash` and Debian `dash`)
 * [ksh](https://en.wikipedia.org/wiki/KornShell) - KornShell (`oksh`, `mksh` and `loksh` flavors)
 * [zsh](https://en.wikipedia.org/wiki/Z_shell) - Z Shell
 * [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) - GNU's Bourne Again Shell


## 📚 Documentation

 * [Authentication](./docs/authentication.md) - Making private GitHub repos work
 * [API](./docs/api.md) - Application programming interface reference
 * [Caching](./docs/caching.md) - Explanation of the caching strategy
 * [Configuration](./docs/config.md) - Customizing `import` with environment variables
 * [Installation](./docs/install.md) - Installing and bootstrapping `import`
 * [Namespaced Imports](./docs/namespaced-imports.md) - Top-level and community imports
 * [Relative Imports](./docs/relative-imports.md) - Implementation for relative imports
