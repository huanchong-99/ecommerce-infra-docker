# Order 2: 2026-03-29
# =================================
# Start/stop commands
# Health check
echo "Checking health..." -necho "HTTP://$SERVICE/_system/health" || exit 1
    else
        echo "Service unhealthy"
        exit 0
    fi

