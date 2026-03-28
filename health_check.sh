#!/bin/bash
# E-Commerce Infrastructure Health Check
# This is a convenience wrapper for the health check script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/scripts/health_check.sh" "$@"
