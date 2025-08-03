#!/usr/bin/env bash

set -eo pipefail

TERM_GRACE_PERIOD=${TERM_GRACE_PERIOD:-10}

if [ "$#" -eq 0 ]; then
  set -- start
fi

export PHOTOPRISM_ORIGINALS_PATH=${PHOTOPRISM_ORIGINALS_PATH-/photoprism/originals}
export PHOTOPRISM_IMPORT_PATH=${PHOTOPRISM_IMPORT_PATH-/photoprism/import}
export PHOTOPRISM_STORAGE_PATH=${PHOTOPRISM_STORAGE_PATH-/photoprism/storage}

_term() {
  printf "\nCaught SIGTERM, forwarding to app..\n" >&2
  kill -TERM "$child" 2>/dev/null || true

  ( sleep "$GRACE_PERIOD"
    if kill -0 "$child" 2>/dev/null; then
      echo "App didn't exit in ${GRACE_PERIOD}s - force-killing.." >&2
      kill -KILL "$child" 2>/dev/null || true
    fi
  ) &
}
_int() {
  printf "\nCaught SIGINT, forwarding to app..\n" >&2
  kill -INT "$child" 2>/dev/null || true

  ( sleep "$GRACE_PERIOD"
    if kill -0 "$child" 2>/dev/null; then
      echo "App didn't exit in ${GRACE_PERIOD}s - force-killing.." >&2
      kill -KILL "$child" 2>/dev/null || true
    fi
  ) &
}

trap _term SIGTERM
trap _int SIGINT

echo "Starting photoprism.."

/photoprism/photoprism "$@" &
child=$!

wait "$child"
exit $?
