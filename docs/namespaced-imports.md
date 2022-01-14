## Namespaced Imports

Any `import` where the beginning portion (up to the first slash) of the
URL _does not contain a `.`_ is considered a **namespaced import**.

A namespaced import means that the `IMPORT_SERVER` (which defaults to
https://import.sh) is prepended to the import URL. For example, these
two import invocations are identical:

 * `import "assert"`
 * `import "https://import.sh/assert"`


## Example

Let's take a look at importing this [tootallnate/hello][hello] "Hello World"
import from GitHub:

```bash
#!/usr/bin/env import
import "tootallnate/hello"

hello
# Hello, from @TooTallNate!
```


## The `import.sh` server

The default `IMPORT_SERVER` is https://import.sh, which serves GitHub
repositories that are _"import-compatible"_, according to the following
conventions:

 * The main import syntax is `import <org>/<repo>`
 * The entry point of the import is the file with the name of the repo with a `.sh` suffix
 * If there is no `/` in the import path, then the default org ([importpw][]) is applied
 * Specific tags may be referenced by appending an `@<version>` to the end


## Top-level imports

The [importpw][] GitHub organization houses the top-level namespace imports.
A top-level import happens when there is no `/` in the import path.

For example, the `assert` module includes functions that write simple unit
testing scripts:

```bash
#!/usr/bin/env import
import "assert"

assert 1 = 2
# assertion failed: 1 = 2
```

Here are some useful top-level imports:

 * [array](https://import.sh/array)
 * [assert](https://import.sh/assert)
 * [confirm](https://import.sh/confirm)
 * [dns](https://import.sh/dns)
 * [emitter](https://import.sh/emitter)
 * [http](https://import.sh/http)
 * [os](https://import.sh/os)
 * [path](https://import.sh/path)
 * [prompt](https://import.sh/prompt)
 * [querystring](https://import.sh/querystring)
 * [string](https://import.sh/string)
 * [tcp](https://import.sh/tcp)

See the [importpw][] org on GitHub for the complete listing of repositories.


## Community imports

Here are some GitHub repositories that are known to be compatible with `import`:

 * [kward/log4sh](https://import.sh/kward/log4sh)
 * [kward/shflags](https://import.sh/kward/shflags)
 * [kward/shunit2](https://import.sh/kward/shunit2)
 * [robwhitby/shakedown](https://import.sh/robwhitby/shakedown)
 * [tootallnate/nexec](https://import.sh/tootallnate/nexec)

(Send a [pull request](https://github.com/importpw/import/pulls) if you would like to have an import listed here)

[hello]: https://github.com/TooTallNate/hello
[importpw]: https://github.com/importpw
