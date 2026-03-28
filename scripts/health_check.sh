#!/bin/bash
# E-Commerce Microservices Health Check Script
# Usage: ./health_check.sh [service_name]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Service endpoints
declare -A SERVICES=(
    ["api-gateway"]="http://localhost/nginx-health"
    ["user-service"]="http://localhost:8080/actuator/health"
    ["product-service"]="http://localhost:8080/actuator/health"
    ["order-service"]="http://localhost:8080/actuator/health"
    ["web-frontend"]="http://localhost:3000/api/health"
    ["redis"]="redis-cli ping"
    ["rabbitmq"]="rabbitmq-diagnostics -q ping"
)

check_service() {
    local service=$1
    local url=${SERVICES[$service]}

    if [ -z "$url" ]; then
        echo -e "${YELLOW}Unknown service: $service${NC}"
        return 1
    fi

    echo -ne "Checking $service... "

    if [[ "$service" == "redis" ]]; then
        if docker exec ecommerce-redis redis-cli ping | grep -q "PONG"; then
            echo -e "${GREEN}✓ Healthy${NC}"
            return 0
        fi
    elif [[ "$service" == "rabbitmq" ]]; then
        if docker exec ecommerce-rabbitmq rabbitmq-diagnostics -q ping > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Healthy${NC}"
            return 0
        fi
    else
        if curl -sf "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Healthy${NC}"
            return 0
        fi
    fi

    echo -e "${RED}✗ Unhealthy${NC}"
    return 1
}

check_all() {
    echo "========================================="
    echo "  E-Commerce Services Health Check"
    echo "========================================="
    echo ""

    local failed=0

    for service in "${!SERVICES[@]}"; do
        if ! check_service "$service"; then
            ((failed++))
        fi
    done

    echo ""
    echo "========================================="

    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}All services are healthy!${NC}"
        exit 0
    else
        echo -e "${RED}$failed service(s) are unhealthy${NC}"
        exit 1
    fi
}

# Main logic
if [ $# -eq 0 ]; then
    check_all
else
    check_service "$1"
fi

