# 🚀 Delivery App

A production-ready food delivery application built with **Clean Architecture**, **Domain-Driven Design**, and modern best practices.

---

## 📋 Project Overview

**Tech Stack:**
- **Backend:** PHP 8.4 + Apache 2.4
- **Frontend:** Flutter (Mobile App)
- **Database:** MySQL 8.0
- **Cache:** Redis 7
- **Containerization:** Docker & Docker Compose
- **Security:** ModSecurity + OWASP CRS

**Architecture:**
- Clean Architecture (Domain, Application, Infrastructure, Presentation)
- Domain-Driven Design (DDD)
- CQRS for complex operations
- Repository pattern
- Event-driven notifications

---

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose installed ([Installation Guide](DOCKER_TUTORIAL.md))
- Git

### Installation

1. **Clone the repository** (or create project directory)
   ```bash
   cd /home/regynald/Sites/deliveryapp
   ```

2. **Copy environment file**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Build and start services**
   ```bash
   docker compose up -d
   ```

4. **Access the application**
   - Backend: http://localhost:8080
   - phpMyAdmin: http://localhost:8081

---

## 📁 Project Structure

```
deliveryapp/
├── backend/                    # PHP Backend
│   ├── src/
│   │   ├── Domain/            # Business logic (entities, value objects)
│   │   ├── Application/       # Use cases (CreateUser, PlaceOrder)
│   │   ├── Infrastructure/    # External services (DB, APIs, Email)
│   │   └── Presentation/      # Controllers (HTTP layer)
│   ├── config/                # Configuration files
│   ├── public/                # Entry point (index.php)
│   └── tests/                 # PHPUnit tests
├── mobile/                    # Flutter Mobile App
│   └── lib/
├── docker/                    # Docker configurations
│   ├── php/
│   │   ├── Dockerfile         # PHP 8.4 + Apache image
│   │   └── php.ini           # PHP configuration
│   ├── apache/
│   │   └── delivery-app.conf # Virtual host config
│   └── mysql/
│       └── my.cnf            # MySQL optimization
├── docker-compose.yml         # Multi-container orchestration
├── DOCKER_TUTORIAL.md        # Docker learning guide
└── README.md                 # This file
```

---

## 🐳 Docker Services

| **Service** | **Port** | **Description** |
|-------------|----------|-----------------|
| backend | 8080 | PHP 8.4 + Apache (Backend API) |
| database | 3306 | MySQL 8.0 |
| cache | 6379 | Redis 7 |
| phpmyadmin | 8081 | Database management UI |

---

## 🛠️ Development Workflow

### Start Services
```bash
docker compose up -d
```

### Stop Services
```bash
docker compose down
```

### View Logs
```bash
docker compose logs -f backend
```

### Execute Commands in Container
```bash
# Access PHP container shell
docker compose exec backend bash

# Run Composer
docker compose exec backend composer install

# Run tests
docker compose exec backend ./vendor/bin/phpunit
```

### Rebuild Containers
```bash
docker compose up -d --build
```

---

## 📚 Learning Resources

### Sprint 0: Foundation & Learning

1. **[Docker Fundamentals](DOCKER_TUTORIAL.md)** - Learn containerization basics
2. **Setup Local Development** - PHP, Composer, Flutter ✅
3. **[Architecture Documentation](docs/architecture.md)** - Clean Architecture principles ✅

### Architecture Documentation (Sprint 0 - Complete)

- **[Architecture Overview](docs/architecture.md)** - Main architecture reference
- **[Clean Architecture Guide](docs/architecture/clean-architecture.md)** - Layer responsibilities and patterns
- **[API Specification (OpenAPI 3.0)](docs/api/openapi.yaml)** - RESTful API contract
- **[Database Schema & ERD](docs/database/schema.md)** - Database design with relationships
- **[Database Migrations](docs/database/migrations/)** - SQL migration files
- **[Seed Data](docs/database/seeds/)** - Development test data

---

## 🔒 Security Features

- [x] Input validation
- [x] SQL injection protection (prepared statements)
- [x] XSS prevention (output escaping)
- [x] CSRF token validation
- [x] JWT authentication
- [x] Password hashing (bcrypt)
- [x] Security headers (X-Frame-Options, CSP, etc.)
- [x] ModSecurity WAF (production)

---

## 🧪 Testing

```bash
# Run all tests
docker compose exec backend ./vendor/bin/phpunit

# Run specific test
docker compose exec backend ./vendor/bin/phpunit tests/Unit/UserTest.php

# Coverage report
docker compose exec backend ./vendor/bin/phpunit --coverage-html coverage/
```

---

## 📖 API Documentation

- **[OpenAPI 3.0 Specification](docs/api/openapi.yaml)** - Full API contract ✅
- **Swagger UI:** http://localhost:8080/api/docs (coming in Sprint 1-2)

To view the OpenAPI spec:
```bash
# Copy the content of docs/api/openapi.yaml
# Paste into: https://editor.swagger.io/
```

---

## 🚀 Deployment

See deployment guides:
- **Development:** `docker-compose.yml`
- **Production:** `docker-compose.prod.yml` (coming in Sprint 9)

---

## 🤝 Contributing

1. Follow PSR-12 coding standards
2. Write unit tests for new features (80%+ coverage)
3. Document API endpoints (OpenAPI)
4. Security review before merging
5. All code in English

---

## 📄 License

This project is for educational purposes (portfolio project).

---

## 🙋 Support

For issues or questions:
1. Check [DOCKER_TUTORIAL.md](DOCKER_TUTORIAL.md)
2. Review error logs: `docker compose logs`
3. Inspect containers: `docker compose ps`

---

**Built with ❤️ using Clean Architecture & DDD**
