## 🔨 Configuration

`import` is configurable via the following environment variables:

|       Name      | Description                                                                                        |
|:---------------:|----------------------------------------------------------------------------------------------------|
| `IMPORT_CACHE`  | The directory where imported files will be cached. Defaults to `~/.import-cache`.                  |
| `IMPORT_CURL_OPTS` | Additional options to pass to `curl`. See the [manpage](https://curl.haxx.se/docs/manpage.html) for its docs. |
| `IMPORT_DEBUG`  | If this variable is set, then debugging information related to `import` will be printed to stderr. |
| `IMPORT_RELOAD` | If this variable is set, then all `import` calls will force-reload from the source URL.            |
| `IMPORT_SERVER` | The server to use for [implicit imports](./implicit-imports.md). Defaults to `https://import.pw`.  |
