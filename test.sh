#!/bin/sh
set -eu

IMPORT_CACHE=cache
IMPORT_DEBUG=1
IMPORT_RELOAD=1
source "./import.sh"

import "import.pw/assert@2.1.1"
import "http://import.pw/assert@2.1.1"
import "https://import.pw/assert@2.1.1"
print=1 import "import.pw/assert@2.1.1"
print=1 import "http://import.pw/assert@2.1.1"
print=1 import "https://import.pw/assert@2.1.1"
tree cache
#assert 1 = 2
assert 1 = 1
