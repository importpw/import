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

# Test 404
r=0
import does_not_exist || r="$?"
test "$r" -ne 0


echo "Tests passed!"
