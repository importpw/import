# Implicit Imports

Any `import` where the beginning portion (up to the first slash) of the
URL _does not contain a `.`_ is considered an **implicit import**.

An implicit import means that the `IMPORT_SERVER`, which defaults to
https://import.pw, is prepended to the import URL. For example, these
import invocations are identical:

 * `import assert`
 * `import import.pw/assert`
 * `import https://import.pw/assert`


## The `import.pw` server

The default `IMPORT_SERVER` is https://import.pw. This server proxies GitHub
repositories that are "import-compatible" according to its convention.
