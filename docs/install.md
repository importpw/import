## 🔽 Installation

`import` is a single, self-contained shell script. Installation is as simple
as downloading the script into your `$PATH` and giving it executable permissions.
Alternatively, it can be downloaded automatically within a script that uses `import`.

### 👢 Bootstrapping the `import` function

The installation can be anywhere on the `$PATH`. For example, to install `import` to
`/usr/local/bin`, run the following:

```bash
curl -sfLS https://import.sh > /usr/local/bin/import
chmod +x /usr/local/bin/import
```

Once you have the `import` script installed, there are two preferred ways to
utilize it in your shell scripts: _shebang_ or _source_.


#### Shebang

The most straightforward way to specify `import` as the entry point of the script
using the "shebang" feature of executable files:

```bash
#!/usr/bin/env import

type import
```

Note that this method will use the interpreter located at `/bin/sh`, which usually
implies baseline POSIX features. If you need more control over which interpreter
is used then see the next method.

#### Source

Another way to bootstrap `import` is to simply source it into your script.
This method gives you control over which interpreter is used. For example,
if you need bash-specific features, you can specify to use it in the shebang,
and then source the `import` script:

```bash
#!/bin/bash

. "$(command -v import)"

type import
```

### 🦿 Automatic download

An alternative approach is to automatically download `import` in your shell
script itself without requiring manual installation.

#### Eval

It is possible to `curl` + `eval` the import function directly into your shell
script.

```bash
#!/bin/sh

eval "$(curl -sfLS https://import.sh)"

type import
```

Note that this method is not as ideal as the shebang/sourcing methods, because
this version incurs an HTTP request to retrieve the import function every time
the script is run, and it won't work offline.

#### Download & Cache

Finally, it is possible to download and cache the `import` script itself by
using the following snippet. This combines the convenience of the eval approach
without the cost of an HTTP request on each run, but requires a slightly unwieldy
bit of code in each shell script that uses `import`.

```bash
#!/bin/sh

[ "$(uname -s)" = "Darwin" ] && __i="$HOME/Library/Caches" || __i="$HOME/.cache" && __i="${IMPORT_CACHE:-${XDG_CACHE_HOME:-${LOCALAPPDATA:-${__i}}}/import.sh}/import" && [ -r "$__i" ] || curl -sfLSo "$__i" --create-dirs https://import.sh && . "$__i" && unset __i

type import
```

Explanation: the complexity lies almost completely in finding out the default
cache location on different operating systems in sync with the `import` script
as detailed in the [caching](caching.md) documentation. Following that, the
snippet checks if the `import` script exists in the cache, downloads and stores
it via `curl` if is missing, and finally sources it.
