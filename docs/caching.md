# 💸 Caching

Caching is a core concept in `import`. Scripts are downloaded _exactly once_, and
then cached on your filesystem _forever_ (or if the `IMPORT_RELOAD=1` env var is
set).

```bash
#!/usr/bin/import
IMPORT_CACHE="/tmp" IMPORT_DEBUG=1 IMPORT_RELOAD=1 import assert
```

If you run this example, then you 
