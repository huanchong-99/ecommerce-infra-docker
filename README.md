# E-Commerce Microservices Infrastructure

This repository contains the Docker Compose configuration and supporting files for running an e-commerce microservices application.

## Architecture Overview

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                    Public Network                        │
                    │                                                         │
                    │  ┌─────────────┐                                        │
                    │  │   Browser   │                                        │
                    │  └──────┬──────┘                                        │
                    │         │                                               │
                    │         ▼                                               │
                    │  ┌─────────────┐      ┌─────────────────────────────┐  │
                    │  │ API Gateway │      │     Internal Network        │  │
                    │  │   (Nginx)   │──────│    172.28.0.0/16           │  │
                    │  │   Port 80   │      │                             │  │
                    │  └─────────────┘      │  ┌─────────────────────┐   │  │
                    │                       │  │   Web Frontend      │   │  │
                    │                       │  │   (Next.js:3000)    │   │  │
                    │                       │  └─────────────────────┘   │  │
                    │                       │                             │  │
                    │                       │  ┌──────────┐ ┌──────────┐ │  │
                    │                       │  │  User    │ │ Product  │ │  │
                    │                       │  │ Service  │ │ Service  │ │  │
                    │                       │  │  :8080   │ │  :8080   │ │  │
                    │                       │  └──────────┘ └──────────┘ │  │
                    │                       │                             │  │
                    │                       │  ┌──────────┐ ┌──────────┐ │  │
                    │                       │  │  Order   │ │  Redis   │ │  │
                    │                       │  │ Service  │ │  :6379   │ │  │
                    │                       │  │  :8080   │ │          │ │  │
                    │                       │  └──────────┘ └──────────┘ │  │
                    │                       │                             │  │
                    │                       │  ┌──────────┐ ┌──────────┐ │  │
                    │                       │  │RabbitMQ  │ │PostgreSQL│ │  │
                    │                       │  │  :5672   │ │  :5432   │ │  │
                    │                       │  └──────────┘ └──────────┘ │  │
                    │                       └─────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────┘
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| API Gateway | 80 | Nginx reverse proxy with rate limiting |
| Web Frontend | 3000 | Next.js application |
| User Service | 8080 | User authentication and management (Spring Boot) |
| Product Service | 8080 | Product catalog and inventory (Spring Boot) |
| Order Service | 8080 | Order processing and cart (Spring Boot) |
| PostgreSQL | 5432 | Database (separate instance per service) |
| Redis | 6379 | Caching and session storage |
| RabbitMQ | 5672/15672 | Message broker (management UI on 15672) |

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 8GB+ RAM recommended
- 20GB+ disk space

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/huanchong-99/ecommerce-infra-docker.git
   cd ecommerce-infra
   ```

2. **Configure environment variables**
   ```bash
   # Copy example env files
   cp env/user-service.env.example env/user-service.env
   cp env/product-service.env.example env/product-service.env
   cp env/order-service.env.example env/order-service.env
   cp env/web-frontend.env.example env/web-frontend.env
   
   # Edit the files with your production values
   ```

3. **Start the infrastructure**
   ```bash
   docker-compose up -d
   ```

4. **Check service health**
   ```bash
   ./health_check.sh
   ```

5. **Access the application**
   - Frontend: http://localhost
   - RabbitMQ Management: http://localhost:15672 (admin/rabbitmq123)

## Configuration

### Environment Files

Each service has its own environment configuration:

- `env/user-service.env` - User service configuration
- `env/product-service.env` - Product service configuration  
- `env/order-service.env` - Order service configuration
- `env/web-frontend.env` - Frontend configuration

### SSL/TLS Configuration

Place your SSL certificates in `nginx/ssl/`:
- `cert.pem` - SSL certificate
- `key.pem` - Private key

## Development

### Building Services

```bash
# Build all services
docker-compose build

# Build specific service
docker-compose build user-service
```

### Viewing Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f user-service
```

### Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Health Checks

Run the health check script to verify all services:

```bash
./health_check.sh              # Check all services
./health_check.sh user-service # Check specific service
```

## Monitoring Stack (Optional)

To enable Elasticsearch for search functionality:

```bash
docker-compose --profile search up -d
```

## Network Configuration

- **Public Network**: `ecommerce-public` - External access
- **Internal Network**: `ecommerce-internal` (172.28.0.0/16) - Service-to-service communication

## Security Notes

⚠️ **Important**: Before deploying to production:

1. Change all default passwords
2. Update JWT secret keys
3. Configure SSL/TLS certificates
4. Review and restrict network access
5. Enable authentication for databases
6. Set up proper logging and monitoring

## Troubleshooting

### Service won't start

```bash
# Check service logs
docker-compose logs user-service

# Check container status
docker-compose ps
```

### Database connection issues

```bash
# Verify database is healthy
docker-compose ps user-db

# Connect to database
docker exec -it ecommerce-user-db psql -U useradmin -d userdb
```

### Reset everything

```bash
docker-compose down -v
docker-compose up -d
```

## License

MIT License
