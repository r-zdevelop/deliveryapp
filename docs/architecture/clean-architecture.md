# Clean Architecture - Delivery App

**Purpose:** Define the architectural layers and responsibilities for maintainable, testable, and scalable code.

**Sprint:** Sprint 0 - Foundation & Learning

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Layer Responsibilities](#layer-responsibilities)
3. [Dependency Rule](#dependency-rule)
4. [Data Flow](#data-flow)
5. [Practical Examples](#practical-examples)
6. [Best Practices](#best-practices)

---

## Architecture Overview

The Delivery App follows **Clean Architecture** principles with **Domain-Driven Design (DDD)** patterns.

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│  Controllers │ HTTP Request/Response │ JSON Serialization       │
│  src/Presentation/Controllers/                                  │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Calls
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                        APPLICATION LAYER                         │
│  Use Cases │ Commands │ Queries │ DTOs │ Orchestration         │
│  src/Application/                                               │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Uses
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                           DOMAIN LAYER                           │
│  Entities │ Value Objects │ Domain Events │ Business Rules      │
│  src/Domain/                                                    │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Implemented by
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      INFRASTRUCTURE LAYER                        │
│  Database │ APIs │ Email │ Payment │ External Services          │
│  src/Infrastructure/                                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## Layer Responsibilities

### 1. Domain Layer (Core Business Logic)

**Location:** `src/Domain/`

**Purpose:** Contains pure business logic with zero external dependencies.

**Components:**

#### Entities
Business objects with unique identity and lifecycle.

```php
src/Domain/User/Entity/User.php
src/Domain/Restaurant/Entity/Restaurant.php
src/Domain/Order/Entity/Order.php
src/Domain/Delivery/Entity/DeliveryDriver.php
```

#### Value Objects
Immutable objects without identity (e.g., Email, Money, Address).

```php
src/Domain/User/ValueObject/Email.php
src/Domain/User/ValueObject/Password.php
src/Domain/Order/ValueObject/Money.php
src/Domain/Shared/ValueObject/Address.php
```

#### Repository Interfaces
Define contracts for data access (implemented in Infrastructure).

```php
src/Domain/User/Repository/UserRepositoryInterface.php
src/Domain/Order/Repository/OrderRepositoryInterface.php
```

#### Domain Events
Represent things that happened in the domain.

```php
src/Domain/Order/Event/OrderPlacedEvent.php
src/Domain/Delivery/Event/DeliveryDriverAssignedEvent.php
```

#### Domain Services
Business logic that doesn't fit in entities.

```php
src/Domain/Order/Service/OrderPricingService.php
src/Domain/Delivery/Service/DriverAssignmentService.php
```

**Rules:**
- ✅ No framework dependencies
- ✅ No database code
- ✅ Pure PHP classes
- ✅ Framework-agnostic
- ❌ No HTTP, no SQL, no third-party libs

---

### 2. Application Layer (Use Cases)

**Location:** `src/Application/`

**Purpose:** Orchestrates domain logic to fulfill specific use cases.

**Components:**

#### Commands (Write Operations)
Handle state changes (CREATE, UPDATE, DELETE).

```php
src/Application/User/Command/CreateUser/CreateUserCommand.php
src/Application/User/Command/CreateUser/CreateUserHandler.php
src/Application/Order/Command/PlaceOrder/PlaceOrderCommand.php
src/Application/Order/Command/PlaceOrder/PlaceOrderHandler.php
```

#### Queries (Read Operations)
Handle data retrieval (GET operations).

```php
src/Application/Restaurant/Query/ListRestaurants/ListRestaurantsQuery.php
src/Application/Restaurant/Query/ListRestaurants/ListRestaurantsHandler.php
src/Application/Order/Query/GetOrderDetails/GetOrderDetailsQuery.php
```

#### DTOs (Data Transfer Objects)
Transfer data between layers.

```php
src/Application/User/DTO/UserDTO.php
src/Application/Order/DTO/OrderDTO.php
```

**Example Flow:**

```
HTTP Request (JSON)
  → Controller
  → CreateUserCommand
  → CreateUserHandler (calls Domain + Infrastructure)
  → UserDTO
  → JSON Response
```

**Rules:**
- ✅ Depends on Domain layer
- ✅ Defines interfaces for Infrastructure
- ✅ Contains business workflows
- ❌ No HTTP details
- ❌ No database implementations

---

### 3. Infrastructure Layer (External Services)

**Location:** `src/Infrastructure/`

**Purpose:** Implements interfaces defined by Domain/Application layers.

**Components:**

#### Persistence
Database implementations of repositories.

```php
src/Infrastructure/Persistence/MySQL/UserRepository.php
src/Infrastructure/Persistence/MySQL/OrderRepository.php
src/Infrastructure/Persistence/Redis/SessionStore.php
```

#### HTTP Layer
Request/Response handling.

```php
src/Infrastructure/Http/Router.php
src/Infrastructure/Http/Request.php
src/Infrastructure/Http/Response.php
src/Infrastructure/Http/Middleware/
```

#### Security
Authentication, authorization, encryption.

```php
src/Infrastructure/Security/JwtManager.php
src/Infrastructure/Security/PasswordHasher.php
src/Infrastructure/Security/CsrfTokenValidator.php
```

#### External Services
Third-party integrations.

```php
src/Infrastructure/Payment/StripeGateway.php
src/Infrastructure/Notification/EmailService.php
src/Infrastructure/Notification/PushNotificationService.php
src/Infrastructure/Geolocation/GoogleMapsService.php
```

#### Logging & Monitoring

```php
src/Infrastructure/Logging/MonologLogger.php
src/Infrastructure/Monitoring/SentryErrorTracker.php
```

**Rules:**
- ✅ Implements Domain interfaces
- ✅ Handles external dependencies
- ✅ Database, APIs, file system
- ❌ No business logic

---

### 4. Presentation Layer (Controllers)

**Location:** `src/Presentation/Controllers/`

**Purpose:** Handle HTTP requests and responses.

**Components:**

```php
src/Presentation/Controllers/UserController.php
src/Presentation/Controllers/RestaurantController.php
src/Presentation/Controllers/OrderController.php
src/Presentation/Controllers/DeliveryController.php
```

**Responsibilities:**
1. Parse HTTP request (JSON, form data, headers)
2. Validate input format (not business rules)
3. Call appropriate Use Case (Application layer)
4. Format response (JSON, XML, etc.)
5. Handle HTTP status codes

**Rules:**
- ✅ Thin controllers (no business logic)
- ✅ Dependency injection
- ✅ Input validation
- ❌ No direct database access
- ❌ No business logic

---

## Dependency Rule

**CRITICAL:** Dependencies must point **INWARD** only.

```
Presentation → Application → Domain ← Infrastructure
     ↓              ↓           ↑
  (HTTP)      (Use Cases)  (Pure Logic)
                              ↑
                    Infrastructure implements
```

### What This Means:

1. **Domain** knows nothing about other layers
2. **Application** depends only on Domain
3. **Infrastructure** implements Domain interfaces
4. **Presentation** depends on Application

### Dependency Inversion Example:

❌ **BAD** (Domain depends on Infrastructure):
```php
// Domain/User/Entity/User.php
class User {
    public function save() {
        $pdo = new PDO(...); // ❌ Domain depends on database!
        $pdo->exec("INSERT INTO users...");
    }
}
```

✅ **GOOD** (Domain defines interface, Infrastructure implements):
```php
// Domain/User/Repository/UserRepositoryInterface.php
interface UserRepositoryInterface {
    public function save(User $user): void;
}

// Infrastructure/Persistence/MySQL/UserRepository.php
class UserRepository implements UserRepositoryInterface {
    public function save(User $user): void {
        $this->pdo->exec("INSERT INTO users...");
    }
}
```

---

## Data Flow

### Example: Create New User

```
1. HTTP POST /api/users
   ↓
2. Presentation/Controllers/UserController::register()
   ↓
3. Application/User/Command/CreateUserHandler::handle()
   ↓ (calls)
4. Domain/User/Entity/User::create() ← Business rules
   ↓
5. Infrastructure/Persistence/MySQL/UserRepository::save()
   ↓
6. Domain/User/Event/UserRegisteredEvent dispatched
   ↓
7. Application returns UserDTO
   ↓
8. Presentation/Controllers/UserController returns JSON response
```

### Example: Get Order Details

```
1. HTTP GET /api/orders/123
   ↓
2. Presentation/Controllers/OrderController::show()
   ↓
3. Application/Order/Query/GetOrderDetailsHandler::handle()
   ↓
4. Infrastructure/Persistence/MySQL/OrderRepository::findById()
   ↓
5. Domain/Order/Entity/Order (populated from DB)
   ↓
6. Application returns OrderDTO
   ↓
7. Presentation/Controllers/OrderController returns JSON response
```

---

## Practical Examples

### Example 1: User Registration Flow

**1. Controller (Presentation)**
```php
// src/Presentation/Controllers/UserController.php
class UserController {
    public function register(Request $request, CreateUserHandler $handler): Response {
        // 1. Extract & validate input
        $command = new CreateUserCommand(
            name: $request->input('name'),
            email: $request->input('email'),
            password: $request->input('password')
        );

        // 2. Execute use case
        $userDTO = $handler->handle($command);

        // 3. Return response
        return new JsonResponse($userDTO, 201);
    }
}
```

**2. Use Case Handler (Application)**
```php
// src/Application/User/Command/CreateUser/CreateUserHandler.php
class CreateUserHandler {
    public function __construct(
        private UserRepositoryInterface $userRepository,
        private PasswordHasherInterface $passwordHasher
    ) {}

    public function handle(CreateUserCommand $command): UserDTO {
        // 1. Create domain entity
        $user = User::create(
            name: $command->name,
            email: new Email($command->email),
            password: Password::fromPlainText($command->password, $this->passwordHasher)
        );

        // 2. Persist
        $this->userRepository->save($user);

        // 3. Return DTO
        return UserDTO::fromEntity($user);
    }
}
```

**3. Domain Entity**
```php
// src/Domain/User/Entity/User.php
class User {
    private UserId $id;
    private string $name;
    private Email $email;
    private Password $password;

    public static function create(string $name, Email $email, Password $password): self {
        // Business rule: Email must be unique (checked in repository)
        // Business rule: Password must meet complexity requirements

        $user = new self();
        $user->id = UserId::generate();
        $user->name = $name;
        $user->email = $email;
        $user->password = $password;

        return $user;
    }
}
```

**4. Repository Implementation (Infrastructure)**
```php
// src/Infrastructure/Persistence/MySQL/UserRepository.php
class UserRepository implements UserRepositoryInterface {
    public function save(User $user): void {
        $stmt = $this->pdo->prepare(
            "INSERT INTO users (id, name, email, password_hash) VALUES (?, ?, ?, ?)"
        );
        $stmt->execute([
            $user->getId()->toString(),
            $user->getName(),
            $user->getEmail()->toString(),
            $user->getPassword()->getHash()
        ]);
    }
}
```

---

## Best Practices

### 1. Keep Domain Pure
✅ **DO:**
- Pure PHP classes
- Framework-agnostic
- Testable without database

❌ **DON'T:**
- Use Eloquent, Doctrine annotations
- Depend on frameworks
- Mix HTTP/SQL logic

---

### 2. Use Value Objects
✅ **DO:**
```php
class Email {
    public function __construct(private string $value) {
        if (!filter_var($value, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException();
        }
    }
}

$user = new User(email: new Email('test@example.com')); // ✅ Type-safe
```

❌ **DON'T:**
```php
$user = new User(email: 'invalid-email'); // ❌ No validation
```

---

### 3. Dependency Injection
✅ **DO:**
```php
class CreateUserHandler {
    public function __construct(
        private UserRepositoryInterface $repository
    ) {}
}
```

❌ **DON'T:**
```php
class CreateUserHandler {
    public function __construct() {
        $this->repository = new UserRepository(); // ❌ Hard-coded dependency
    }
}
```

---

### 4. Single Responsibility
Each class should do ONE thing:
- `User` entity → Represents user business logic
- `UserRepository` → Data persistence
- `UserController` → HTTP handling
- `CreateUserHandler` → User registration workflow

---

## Folder Structure Reference

```
backend/src/
├── Domain/                          # Business logic (framework-agnostic)
│   ├── User/
│   │   ├── Entity/User.php
│   │   ├── ValueObject/
│   │   │   ├── UserId.php
│   │   │   ├── Email.php
│   │   │   └── Password.php
│   │   ├── Repository/UserRepositoryInterface.php
│   │   ├── Event/UserRegisteredEvent.php
│   │   └── Exception/UserAlreadyExistsException.php
│   ├── Restaurant/
│   ├── Order/
│   ├── Delivery/
│   └── Payment/
│
├── Application/                     # Use cases
│   ├── User/
│   │   ├── Command/
│   │   │   └── CreateUser/
│   │   │       ├── CreateUserCommand.php
│   │   │       └── CreateUserHandler.php
│   │   ├── Query/
│   │   │   └── GetUser/
│   │   │       ├── GetUserQuery.php
│   │   │       └── GetUserHandler.php
│   │   └── DTO/UserDTO.php
│   ├── Order/
│   └── Restaurant/
│
├── Infrastructure/                  # External integrations
│   ├── Persistence/
│   │   └── MySQL/
│   │       ├── UserRepository.php
│   │       └── OrderRepository.php
│   ├── Http/
│   │   ├── Router.php
│   │   ├── Request.php
│   │   └── Response.php
│   ├── Security/
│   │   ├── JwtManager.php
│   │   └── PasswordHasher.php
│   ├── Payment/
│   │   └── StripeGateway.php
│   └── Notification/
│       ├── EmailService.php
│       └── PushNotificationService.php
│
└── Presentation/                    # HTTP controllers
    └── Controllers/
        ├── UserController.php
        ├── RestaurantController.php
        └── OrderController.php
```

---

## Testing Strategy

### Unit Tests (Domain Layer)
```php
// tests/Unit/Domain/User/Entity/UserTest.php
class UserTest extends TestCase {
    public function test_user_creation_with_valid_data() {
        $user = User::create(
            name: 'John Doe',
            email: new Email('john@example.com'),
            password: Password::fromPlainText('SecurePass123')
        );

        $this->assertInstanceOf(User::class, $user);
        $this->assertEquals('John Doe', $user->getName());
    }
}
```

### Integration Tests (Infrastructure)
```php
// tests/Integration/Infrastructure/Persistence/UserRepositoryTest.php
class UserRepositoryTest extends TestCase {
    public function test_save_user_to_database() {
        $repository = new UserRepository($this->pdo);
        $user = User::create(...);

        $repository->save($user);

        $found = $repository->findById($user->getId());
        $this->assertEquals($user->getId(), $found->getId());
    }
}
```

---

## Common Pitfalls

### ❌ Pitfall 1: Business Logic in Controllers
```php
// BAD: Controller validates business rules
class UserController {
    public function register(Request $request) {
        if (strlen($request->input('password')) < 8) { // ❌ Business rule in controller
            return new JsonResponse(['error' => 'Password too short'], 400);
        }
    }
}
```

✅ **Solution:** Move to Domain
```php
// Domain/User/ValueObject/Password.php
class Password {
    public function __construct(string $plainText) {
        if (strlen($plainText) < 8) { // ✅ Business rule in domain
            throw new InvalidPasswordException('Password must be at least 8 characters');
        }
    }
}
```

---

### ❌ Pitfall 2: Domain Depends on Infrastructure
```php
// BAD: Entity knows about database
class User {
    public function save() {
        $pdo = new PDO(...); // ❌ Domain depends on infrastructure
        $pdo->exec("INSERT INTO users...");
    }
}
```

✅ **Solution:** Use Repository Pattern
```php
// Domain defines interface
interface UserRepositoryInterface {
    public function save(User $user): void;
}

// Infrastructure implements
class UserRepository implements UserRepositoryInterface {
    public function save(User $user): void {
        $this->pdo->exec("INSERT INTO users...");
    }
}
```

---

## Next Level

### 1. Event Sourcing
Store domain events instead of current state.

### 2. CQRS (Command Query Responsibility Segregation)
Separate read and write models.

### 3. Hexagonal Architecture
Another name for Clean Architecture emphasizing ports & adapters.

### 4. Microservices
Split bounded contexts into separate services.

---

## References

- [Clean Architecture (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design (Eric Evans)](https://www.domainlanguage.com/ddd/)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

---

**Last Updated:** 2025-12-03
**Sprint:** Sprint 0 - Foundation & Learning
**Status:** ✅ Complete
