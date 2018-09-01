# Implicit Imports

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
module from GitHub:

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
 * The entry point of the module is the file with the name of the repo with a `.sh` suffix
 * If there is no `/` in the import path, than the default org ([`importpw`][importpw]) is applied
 * Specific tags may be referenced by appending an `@<version>` to the end

[hello]: https://github.com/TooTallNate/hello
[importpw]: https://github.com/importpw
