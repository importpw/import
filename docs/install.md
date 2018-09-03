## Installation

The "quick and dirty" way is to simply `curl` + `eval` the import script:

```bash
eval "$(curl -sfLS https://import.pw)"
```


## 🐔🥚 Bootstrapping the `import` function

Since the `import.sh` file itself defines the `import` function, you naturally
can not _use_ the `import` function to load the import script. This is a classic
chicken vs. egg problem!

However, this involves an HTTP request every time that the shell script is run,
and thus would not work offine and is not as optimized.

A more robust solution is to first cache the import script to the
filesystem, and then `source` it afterwards. For example:

```bash
test -f "$HOME/.import.sh" || curl -sfS https://import.pw > "$HOME/.import.sh"
source "$HOME/.import.sh"
```
