#! /bin/bash

set -e

CONF=$1
shift 1
IMAGES=$@

( kas shell kas/${CONF}.yml -c "bitbake --setscene-only ${IMAGES}" || true ) | sed -e '/^NOTE: .*Started$/d' -e '/^NOTE: Running /d'
kas shell kas/${CONF}.yml -c "bitbake --skip-setscene ${IMAGES}" | sed -e '/^NOTE: .*Started$/d' -e '/^NOTE: Running /d'

export SSTATE_CACHE_DIR=/home/srv/sstate/master

./poky/scripts/sstate-cache-management.sh -d -y

mv build/tmp/deploy/images .
