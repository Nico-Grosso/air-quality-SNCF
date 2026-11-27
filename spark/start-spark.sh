#!/bin/bash

set -e

echo "=============================================="
echo " Spark ${SPARK_VERSION:-4.2.0}"
echo " Role: ${SPARK_ROLE}"
echo " Host: $(hostname)"
echo "=============================================="

case "${SPARK_ROLE}" in

    master)
        echo "Starting Spark Master..."

        /opt/spark/sbin/start-master.sh

        if [ "${JUPYTER_ENABLE}" = "true" ]; then
            echo "Starting JupyterLab..."

            jupyter lab \
                --ip=0.0.0.0 \
                --port="${JUPYTER_PORT:-8888}" \
                --no-browser \
                --allow-root \
                --ServerApp.token='' \
                --ServerApp.password=''
        fi
        ;;

    worker)
        echo "Starting Spark Worker..."
        echo "Master: ${SPARK_MASTER_URL}"

        /opt/spark/sbin/start-worker.sh \
            "${SPARK_MASTER_URL}"

        tail -f /dev/null
        ;;

    history)
        echo "Starting Spark History Server..."

        /opt/spark/sbin/start-history-server.sh

        tail -f /dev/null
        ;;

    *)
        echo "ERROR: Unknown SPARK_ROLE='${SPARK_ROLE}'"
        echo ""
        echo "Valid roles:"
        echo "  master"
        echo "  worker"
        echo "  history"
        exit 1
        ;;

esac