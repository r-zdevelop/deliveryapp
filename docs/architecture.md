# Delivery App - Architecture Documentation

**Sprint:** Sprint 0 - Foundation & Learning
**Status:** ✅ Complete
**Last Updated:** 2025-12-03

---

## Overview

This document serves as the **main architecture reference** for the Delivery App project. All architecture decisions, API contracts, and database designs are documented here.

---

## Documentation Index

### 1. [Clean Architecture](architecture/clean-architecture.md)

**Purpose:** Understand the layered architecture pattern used throughout the project.

**Topics Covered:**
- ✅ Domain, Application, Infrastructure, and Presentation layers
- ✅ Dependency Rule (dependencies point inward)
- ✅ Practical examples (User Registration flow)
- ✅ Repository pattern implementation
- ✅ Value Objects and Entities
- ✅ Best practices and common pitfalls

**Key Takeaway:** Business logic lives in the Domain layer and has zero dependencies on frameworks, databases, or HTTP.

---

### 2. [API Endpoints (OpenAPI 3.0)](api/openapi.yaml)

**Purpose:** RESTful API contract definition.

**Topics Covered:**
- ✅ Authentication endpoints (register, login, refresh)
- ✅ User management (profile, addresses)
- ✅ Restaurant listing and menu retrieval
- ✅ Order placement and tracking
- ✅ Delivery driver operations
- ✅ Payment processing
- ✅ Request/response schemas
- ✅ Error handling and status codes

**Key Takeaway:** All endpoints follow REST conventions with proper HTTP methods and status codes.

**Usage:**
```bash
# View in Swagger Editor
# https://editor.swagger.io/
# Copy and paste the contents of docs/api/openapi.yaml
```

---

### 3. [Database Schema](database/schema.md)

**Purpose:** Normalized relational database design with ERD.

**Topics Covered:**
- ✅ Entity-Relationship Diagram (ERD)
- ✅ 11 core tables (users, orders, restaurants, etc.)
- ✅ Foreign key relationships
- ✅ Indexes for performance
- ✅ Geospatial queries (find nearby restaurants/drivers)
- ✅ Sample SQL queries
- ✅ Security considerations

**Key Takeaway:** Database follows 3NF (Third Normal Form) with proper constraints and indexes.

---

### 4. [Database Migrations](database/migrations/)

**Purpose:** Sequential SQL migrations for schema creation.

**Files:**
```
migrations/
├── 001_create_users_table.sql
├── 002_create_addresses_table.sql
├── 003_create_restaurants_table.sql
├── 004_create_menu_categories_table.sql
├── 005_create_menu_items_table.sql
├── 006_create_delivery_drivers_table.sql
├── 007_create_orders_table.sql
├── 008_create_order_items_table.sql
├── 009_create_order_status_history_table.sql
├── 010_create_payment_methods_table.sql
├── 011_create_payments_table.sql
└── README.md (migration instructions)
```

**Key Takeaway:** Migrations must be run in sequential order due to foreign key dependencies.

**Run migrations:**
```bash
# See docs/database/migrations/README.md for instructions
```

---

### 5. [Seed Data](database/seeds/)

**Purpose:** Development test data for local environment.

**Includes:**
- 9 sample users (customers, restaurant owners, drivers, admin)
- 3 restaurants (Italian, Chinese, Mexican)
- 10 menu categories
- 14 menu items
- 2 delivery drivers
- 1 sample order (with full status history)
- Payment method and transaction

**Key Takeaway:** All test users have password: `password123` (bcrypt hashed).

---

## Architecture Principles

### SOLID Principles

✅ **Single Responsibility:** Each class has one reason to change
✅ **Open/Closed:** Open for extension, closed for modification
✅ **Liskov Substitution:** Subtypes must be substitutable for base types
✅ **Interface Segregation:** Clients shouldn't depend on unused interfaces
✅ **Dependency Inversion:** Depend on abstractions, not concretions

### Clean Architecture Rules

1. **Domain** = Pure business logic (no frameworks, no databases)
2. **Application** = Use cases (orchestrates domain logic)
3. **Infrastructure** = External services (database, APIs, email)
4. **Presentation** = HTTP controllers (thin layer)

### Design Patterns Used

- **Repository Pattern:** Data access abstraction
- **Factory Pattern:** Complex object creation
- **Value Objects:** Immutable domain primitives (Email, Money, Address)
- **Command/Query Separation (CQRS):** Separate read and write models
- **Domain Events:** Publish events when domain state changes

---

## Technology Stack

### Backend
- **PHP:** 8.4
- **Web Server:** Apache 2.4
- **Framework:** None (framework-agnostic architecture)
- **Database:** MySQL 8.0
- **Cache:** Redis 7
- **Security:** ModSecurity + OWASP CRS
- **Payment:** Stripe / PayPal
- **Real-time:** WebSockets (Ratchet/Swoole)

### Frontend
- **Mobile:** Flutter (Dart)

### Infrastructure
- **Containerization:** Docker & Docker Compose
- **CI/CD:** GitHub Actions (planned)
- **Monitoring:** Sentry (planned)
- **Logging:** Monolog

---

## Security Best Practices

### Authentication & Authorization
✅ JWT tokens (RS256 algorithm)
✅ Password hashing (bcrypt, cost factor 12)
✅ Token refresh mechanism
✅ Role-based access control (RBAC)

### Input Validation
✅ Server-side validation (never trust client)
✅ Type checking with PHP 8.4 strict types
✅ Value Objects enforce business rules

### SQL Injection Prevention
✅ Prepared statements (PDO)
✅ Never concatenate user input
✅ ORM usage for complex queries (optional)

### XSS Prevention
✅ Output escaping (htmlspecialchars)
✅ Content-Security-Policy headers
✅ JSON responses (application/json)

### CSRF Protection
✅ CSRF tokens for state-changing operations
✅ SameSite cookie attribute

### Payment Security
✅ Never store full card numbers
✅ Never store CVV
✅ Use payment provider tokens (Stripe/PayPal)
✅ PCI DSS compliance (tokenization)

---

## API Design Guidelines

### REST Conventions
```
GET    /api/v1/restaurants        → List restaurants
GET    /api/v1/restaurants/{id}   → Get restaurant
POST   /api/v1/restaurants        → Create restaurant
PUT    /api/v1/restaurants/{id}   → Update restaurant
DELETE /api/v1/restaurants/{id}   → Delete restaurant
```

### Status Codes
- **200 OK:** Successful GET/PUT
- **201 Created:** Successful POST
- **204 No Content:** Successful DELETE
- **400 Bad Request:** Validation error
- **401 Unauthorized:** Missing/invalid token
- **403 Forbidden:** Insufficient permissions
- **404 Not Found:** Resource doesn't exist
- **500 Internal Server Error:** Server error

### Response Format
```json
{
  "success": true,
  "data": { ... },
  "pagination": {
    "current_page": 1,
    "total_pages": 10,
    "total_items": 100
  }
}
```

### Error Format
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": ["Email is required", "Invalid email format"],
    "password": ["Password must be at least 8 characters"]
  }
}
```

---

## Database Conventions

### Table Naming
- **Plural:** `users`, `orders`, `restaurants`
- **Snake case:** `order_items`, `menu_categories`

### Column Naming
- **Primary key:** `id` (CHAR(36) - UUID v4)
- **Foreign key:** `{table_singular}_id` (e.g., `user_id`, `restaurant_id`)
- **Timestamps:** `created_at`, `updated_at`, `deleted_at`
- **Boolean:** Prefix with `is_` or `has_` (e.g., `is_active`, `has_discount`)

### Indexes
- ✅ Index all foreign keys
- ✅ Index frequently filtered columns (status, created_at)
- ✅ Composite indexes for common query patterns
- ✅ FULLTEXT indexes for search columns

---

## Testing Strategy

### Unit Tests (Domain Layer)
```php
tests/Unit/Domain/User/Entity/UserTest.php
tests/Unit/Domain/Order/ValueObject/MoneyTest.php
```
**Coverage Target:** 80%+

### Integration Tests (Infrastructure)
```php
tests/Integration/Infrastructure/Persistence/UserRepositoryTest.php
tests/Integration/Infrastructure/Http/RouterTest.php
```

### API Tests (Presentation)
```php
tests/Api/Auth/LoginTest.php
tests/Api/Order/PlaceOrderTest.php
```

### End-to-End Tests (Optional)
- Flutter integration tests
- Cypress/Selenium for web admin panel

---

## Development Workflow

### Local Development
```bash
# Start services
docker compose up -d

# Run migrations
# See docs/database/migrations/README.md

# Seed test data
docker compose exec -T database mysql -u delivery_user -p deliveryapp < docs/database/seeds/001_seed_development_data.sql

# Run tests
docker compose exec backend ./vendor/bin/phpunit

# View logs
docker compose logs -f backend
```

### Code Quality
```bash
# Static analysis
docker compose exec backend ./vendor/bin/phpstan analyse

# Code style (PSR-12)
docker compose exec backend ./vendor/bin/phpcs

# Fix code style
docker compose exec backend ./vendor/bin/phpcbf
```

---

## Project Roadmap

### ✅ Sprint 0: Foundation & Learning (Weeks 1-2)
- [x] Learn Docker fundamentals
- [x] Setup local development environment
- [x] **Project Architecture Design** (this document)

### 🚧 Sprint 1-2: Backend Foundation (Weeks 3-6)
- [ ] Implement User domain (entities, value objects, repository)
- [ ] JWT authentication system
- [ ] User registration and login API
- [ ] Unit tests for User domain

### 🔜 Sprint 3-4: Order Management (Weeks 7-10)
- [ ] Restaurant and Menu domain
- [ ] Order placement workflow
- [ ] Order status tracking

### 🔜 Sprint 5-6: Flutter Mobile App (Weeks 11-14)
- [ ] Flutter UI for user registration/login
- [ ] Restaurant listing and menu browsing
- [ ] Order placement screen

### 🔜 Sprint 7-8: Payment & Delivery (Weeks 15-18)
- [ ] Stripe payment integration
- [ ] Delivery driver assignment algorithm
- [ ] Real-time order tracking (WebSockets)

### 🔜 Sprint 9: Deployment & Security (Weeks 19-20)
- [ ] Production Docker Compose configuration
- [ ] ModSecurity WAF setup
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Monitoring and logging

---

## Definition of Done

For **Story 3: Project Architecture Design** to be considered complete:

- [x] Clean Architecture documentation written
- [x] API endpoints defined (OpenAPI 3.0)
- [x] Database schema designed with ERD
- [x] Database migrations created (11 tables)
- [x] Sample seed data prepared
- [x] Documentation reviewed and complete

**Status:** ✅ **COMPLETE**

---

## Next Steps

1. **Sprint 1-2:** Start implementing the User domain
   - Create `src/Domain/User/Entity/User.php`
   - Create `src/Domain/User/ValueObject/Email.php`
   - Create `src/Domain/User/Repository/UserRepositoryInterface.php`
   - Implement `src/Infrastructure/Persistence/MySQL/UserRepository.php`

2. **Move migrations to backend directory** (once permissions are fixed):
   ```bash
   # You'll need to fix permissions first
   mkdir -p backend/database/migrations
   cp docs/database/migrations/*.sql backend/database/migrations/
   ```

3. **Run migrations in your database**:
   ```bash
   # See docs/database/migrations/README.md
   ```

---

## References

- [Clean Architecture (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design (Eric Evans)](https://www.domainlanguage.com/ddd/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [RESTful API Design](https://restfulapi.net/)
- [PSR-12: Extended Coding Style](https://www.php-fig.org/psr/psr-12/)

---

**Last Updated:** 2025-12-03
**Sprint:** Sprint 0 - Foundation & Learning
**Status:** ✅ Complete

---

**Built with ❤️ using Clean Architecture & Domain-Driven Design**
