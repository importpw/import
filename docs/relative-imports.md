## Relative Imports

Any `import` that begins with `./` or `../` is considered a **relative import**.

Relative imports reference a file located _relative_ to the file that is importing
it. This provides a mechanism for modularization (breaking up the logic into
multiple files) and code forking (for example, importing different implementations
of a function based on the shell interpreter).


## Implementation Details

Relative imports are made possible primarily because of the `Location` and/or
`Content-Location` HTTP headers provided by the server that provides the
imported URL.

When a script is imported, the HTTP headers are parsed, and the _final_
`Location`/`Content-Location` header is considered the "location" of the script.
This final URL gets cached to the filesystem in the `locations` directory.

### Example

Perhaps an example will help illustrate. If you inspect the response headers for
the [`tootallnate/hello`](https://import.sh/tootallnate/hello), then you can see
the `content-location` header is present:

```
#!/bin/sh

curl -sI https://import.sh/tootallnate/hello | grep -i location
# content-location: https://raw.githubusercontent.com/tootallnate/hello/master/hello.sh
```

`import` keeps tracks of these URL locations, so that from _within the `hello.sh`
script_, any relative import, let's say `import ./foo.sh`, will be normalized to
relative of the current URL location.
