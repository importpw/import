## 🔽 Installation

`import` is a single, self-contained shell script. Installation is as simple
as downloading the script into your `$PATH` and giving it executable permissions.

For example, to install `import` to `/usr/local/bin`, run the following:

```bash
curl -sfLS https://import.pw > /usr/local/bin/import
chmod +x /usr/local/bin/import
```


## 👢 Bootstrapping the `import` function

Once you have the `import` script installed, there are two preferred ways to
utilize it in your shell scripts: _shebang_ or _source_.


#### Shebang

The most straightforward way to specify `import` as the entry point of the script
using the "shebang" feature of executable files:

```bash
#!/usr/bin/env import

type import
```

By default, `/bin/sh` will be used when invoking your script via shebang. An
explicit shell interpreter may be specified by using the `-s`/`--shell` command
line flags within the shebang. For example:

```bash
#!/usr/bin/env import -s bash

# This code will be executed using `bash` instead of `sh`
```


#### Source

Another way to bootstrap `import` is to simply source it into your script.
This method is useful for times when you do not have control over _how_ the
script is invoked, but you can still execute shell code. For example, within
your `~/.bashrc` file in order to have import available on the command line:

```bash
#!/bin/sh

. "$(which import)"

type import
```


#### Eval

Finally, for scenarios when `import` _is not installed_, it is possible to
`curl` + `eval` the import function directly into your shell script.

```bash
#!/bin/sh

eval "$(curl -sfLS https://import.pw)"

type import
```

Note that this method is not as ideal as the shebang/sourcing methods, because
this version incurs an HTTP request to retrieve the import function every time
the script is run, and it won't work offline.
