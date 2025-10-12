#!/bin/sh
SCRIPT_PATH=$(readlink -f "$0")
echo "SCRIPT_PATH=$SCRIPT_PATH"
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
echo "SCRIPT_DIR=$SCRIPT_DIR"

export ZO_ROOT_USER_EMAIL="<your email>"
export ZO_ROOT_USER_PASSWORD="<your password>"
export ZO_DATA_DIR="$SCRIPT_DIR/data"
export ZO_LOCAL_MODE="true"

export ZO_MAX_FILE_SIZE_IN_MEMORY=128
export ZO_MAX_FILE_RETENTION_TIME=600
export ZO_COMPACT_DATA_RETENTION_DAYS=30
export ZO_TELEMETRY="false"
export RUST_LOG="warn"

export ZO_META_STORE="sqlite"
export ZO_MMDB_DISABLE_DOWNLOAD="true"

# general APIs and web
export ZO_HTTP_PORT=45080
export ZO_GRPC_PORT=45081
# syslog ports (will be deprecated eventually, and you can just use fluent-bit anyway)
#export ZO_TCP_PORT=45514
#export ZO_UDP_PORT=45514

export ZO_WEB_URL="http://localhost:$ZO_HTTP_PORT"
export ZO_BASE_URI="/_observe"

echo Starting openobserve: $ZO_WEB_URL
$SCRIPT_DIR/openobserve &
