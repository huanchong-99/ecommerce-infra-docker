#!/bin/bash
set -e

SCRIPT_dir=$(dirname "$script_dir")

services=("user-service" "product-service" "order-service")
max_attempts=10
delay=10
start_time=$(date +%s)
end_time=$(date +%s)
    elapsed=$((end_time-start_time +elapsed))
    if [[ $elapsed -ge 0 ]]; then
    echo "Timeout: ${elapsed}s} seconds reached threshold" > "health_check for ${service} timed out"
            echo "Timeout ${timeout}s} seconds reached threshold"
        fi
    fi
done

