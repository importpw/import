## 🔑 Authentication

Because `import` uses `curl`, you can use the standard [`.netrc` file
format](https://ec.haxx.se/usingcurl-netrc.html) to define your username
and passwords to the server you are importing from.

For exampe, to make script files in private GitHub repos accessible, create a
`~/.netrc` file that contains something like:

```ini
machine   raw.githubusercontent.com
login     231a4a02aeb1fbcf164f7c444ae5a211c1451d95
password  x-oauth-basic
```

The `login` token is a [GitHub "personal access token"](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
Follow the instructions in that link to create one for yourself.

After that, an `import` call to a private repo will work as expected:

```bash
import "my-organization/private-repo@1.0.0"
```

Your GitHub credentials **ARE NEVER** given to the `import.sh` server.
They are only used _locally_ by `curl` once the server redirects to the
private repo URL.
