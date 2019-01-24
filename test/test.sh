#!/bin/sh
set -eu

./test/start-server.sh &
nginx_pid="$!"
nginx_addr="http://127.0.0.1:12006"
echo "nginx pid $nginx_pid"

# Time for nginx to boot up
sleep 1

finish() {
  echo "Killing nginx (pid $nginx_pid)"
  kill "$nginx_pid"
  exit
}
trap finish EXIT INT QUIT

IMPORT_CACHE=cache
IMPORT_DEBUG=1
IMPORT_RELOAD=1
IMPORT_SERVER="${nginx_addr}"
. "./import.sh"

# Test basic `foo` import
import foo
test "$(foo)" = "foo"

# Test basic import with `@` symbol
import foo@1.0.0
test "$(foo1)" = "foo1"

# Test 404
r=0
import does_not_exist || r="$?"
test "$r" -ne 0

# Test "X-Import-Warning"
if ! import warning 2>&1 | grep "This server has moved to xxxxx.sh" >/dev/null; then
  echo "X-Import-Warning was not rendered" >&2
  exit 1
fi

# Test relative import
import relative
test "$(relative)" = "relative"
test "$(subdir_rel)" = "subdir_rel"

# Test multiple words
import pkg as foo
test "$(foo)" = "this is foo"


echo "Tests passed!"
