#!/bin/bash -eEx

ARANGO_INIT_PORT=8529
ARANGO_ENDPOINT="tcp://127.0.0.1:$ARANGO_INIT_PORT"
export GLIBCXX_FORCE_NEW=1

# check for numa
NUMACTL=""

if [ -d /sys/devices/system/node/node1 ] && [ -f /proc/self/numa_maps ]; then
    if [ "$NUMA" = "" ]; then
        NUMACTL="numactl --interleave=all"
    elif [ "$NUMA" != "disable" ]; then
        NUMACTL="numactl --interleave=$NUMA"
    fi

    if [ "$NUMACTL" != "" ]; then
        if $NUMACTL echo >/dev/null 2>&1; then
            echo "using NUMA $NUMACTL"
        else
            echo "cannot start with NUMA $NUMACTL: please ensure that docker is running with --cap-add SYS_NICE"
            NUMACTL=""
        fi
    fi
fi

# Update if needed
$NUMACTL arangod --config /arango/config \
    --server.endpoint $ARANGO_ENDPOINT \
    --server.authentication=false \
    --log.foreground-tty true \
    --database.auto-upgrade true || exit 1

$NUMACTL arangod --config /arango/config \
    --server.endpoint $ARANGO_ENDPOINT \
    --server.authentication=false \
    --log.foreground-tty true &
pid="$!"
counter=0
ARANGO_UP=0

while [ "$ARANGO_UP" = "0" ]; do
    if [ $counter -gt 0 ]; then
        sleep 1
        echo '.'
    fi

    if [ "$counter" -gt 100 ]; then
        echo "ArangoDB didn't start correctly during init"
        cat /tmp/init-log
        exit 1
    fi

    counter=$((counter + 1))
    ARANGO_UP=1

    $NUMACTL arangosh \
        --server.authentication=false \
        --javascript.execute-string "db._version()" \
        >/dev/null 2>&1 || ARANGO_UP=0
done

if [ "$(id -u)" = "0" ]; then
    foxx server set default http://127.0.0.1:$ARANGO_INIT_PORT
else
    echo Not setting foxx server default because we are not root.
fi

echo "Running init db scripts"
for f in /arango/initdb.d/*; do
    case "$f" in
    *.sh)
        echo "$0: running $f"
        # shellcheck disable=SC1090
        . "$f"
        ;;
    *.js)
        echo "$0: running $f"
        $NUMACTL arangosh --server.authentication false \
            --javascript.execute "$f"
        ;;
    */dumps)
        echo "$0: restoring databases"
        for d in "$f/"*; do
            # shellcheck disable=SC2001
            DBName=$(echo "${d}" | sed "s;$f/;;")
            echo "restoring $d into ${DBName}"
            $NUMACTL arangorestore \
                --server.authentication false \
                --create-database true \
                --include-system-collections true \
                --server.database "$DBName" \
                --input-directory "$d"
        done
        echo
        ;;
    esac
done

if [ "$(id -u)" = "0" ]; then
    foxx server remove default
fi

if ! kill -s TERM "$pid" || ! wait "$pid"; then
    echo >&2 'ArangoDB Init failed.'
    exit 1
fi

echo "Database initialized..."
exec $NUMACTL arangod --config /arango/config \
    --server.authentication=false
