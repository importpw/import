## Implicit Imports

Any `import` where the beginning portion (up to the first slash) of the
URL _does not contain a `.`_ is considered an **implicit import**.

An implicit import means that the `IMPORT_SERVER` (which defaults to
https://import.pw) is prepended to the import URL. For example, these
import invocations are identical:

 * `import assert`
 * `import import.pw/assert`
 * `import https://import.pw/assert`


## Example

Let's take a look at importing this [tootallnate/hello][hello] "Hello World"
import from GitHub:

```bash
#!/usr/bin/env import

import tootallnate/hello

hello
# Hello, from @TooTallNate!
```


## The `import.pw` server

The default `IMPORT_SERVER` is https://import.pw, which serves GitHub
repositories that are "import-compatible" according to its _conventions_:

 * The main import syntax is `import <org>/<repo>`
 * The entry point of the import is the file with the name of the repo with a `.sh` suffix
 * If there is no `/` in the import path, then the default org ([importpw][]) is applied
 * Specific tags may be referenced by appending an `@<version>` to the end


## "Root" imports

The [importpw][] GitHub organization houses the "root" imports. A root import
is implied when there is no `/` in the import path.

For example, the `assert` module helps write simple unit testing scripts:

```bash
#!/usr/bin/env import

import assert@1.0.0

assert 1 = 2
# assertion failed: 1 = 2
```

Some other noteworthy root imports:

 * [confirm](https://import.pw/confirm)
 * [http](https://import.pw/http)
 * [querystring](https://import.pw/querystring)
 * [tcp](https://import.pw/tcp)


# Community imports

Here are some known GitHub repositories that are compatible with `import`:

 * [kward/shunit2](https://import.pw/kward/shunit2)
 * [robwhitby/shakedown](https://import.pw/robwhitby/shakedown)
 * [tootallnate/nexec](https://import.pw/tootallnate/nexec)

(Send a [pull request](https://github.com/importpw/import/pulls) if you would like to have an import listed here)

[hello]: https://github.com/TooTallNate/hello
[importpw]: https://github.com/importpw
