# [import](https://import.pw)

`import` is a simple and fast module system for Bash and other Unix shells.

Inspired by Go's import command, you specify the URI of the shell script,
and the `import` function downloads the file and caches it to `~/.import-cache`,
_forever_.

The code will never change from below your feet, and will continute to work
offline.


## 👋 Example

This gist https://git.io/f4SOX contains a simple `add` shell function:

```bash
add() {
  echo "$(( $1 + $2 ))"
}
```

You can use the `import` function to download, cache, and use that function in
your own script:

```bash
#!/usr/bin/env import

# The gist is downloaded once, cached forever, and then sourced
import "git.io/f4SOX"

add 7 11
# 18
```


## ⚙️ Compatibility

Maximum compatability is the goal for the core `import` function.
`import` is unit tested against the following shell implementations:

 * [`ash`](https://en.wikipedia.org/wiki/Almquist_shell) (Almquist Shell - BusyBox ash and Debian dash)
 * [`ksh`](https://en.wikipedia.org/wiki/KornShell) (KornShell - oksh, mksh and loksh flavors)
 * [`zsh`](https://en.wikipedia.org/wiki/Z_shell) (Z Shell)
 * [`bash`](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) (GNU's Bourne Again SHell)


## 📚Documentation

 * [Install](./docs/install.md) - Installing and bootstrapping `import`
 * [Caching](./docs/caching.md) - Explanation of the caching strategy
 * [Configuration](./docs/config.md) - Customizing `import` with env vars
 * [Authentication](./docs/authentication.md) - Making private GitHub repos work
