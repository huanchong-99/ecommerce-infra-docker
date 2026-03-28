# Monitoring Stack

This directory is reserved for monitoring configuration.

## Recommended Setup

For production monitoring, consider adding:

### Prometheus + Grafana
```yaml
# docker-compose.monitoring.yml
prometheus:
  image: prom/prometheus
  volumes:
    - ./prometheus.yml:/etc/prometheus/prometheus.yml
  ports:
    - "9090:9090"

grafana:
  image: grafana/grafana
  ports:
    - "3001:3000"
  environment:
    - GF_SECURITY_ADMIN_PASSWORD=admin
```

### ELK Stack
- Elasticsearch for log aggregation
- Logstash for log processing
- Kibana for visualization

### Jaeger Tracing
For distributed tracing across microservices.

## Quick Start with Monitoring

```bash
docker-compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d
```
