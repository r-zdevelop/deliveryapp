# Database Schema - Delivery App

**Purpose:** Define normalized database structure with relationships and constraints.

**Sprint:** Sprint 0 - Foundation & Learning

**Database:** MySQL 8.0

---

## Table of Contents

1. [ERD (Entity-Relationship Diagram)](#erd-entity-relationship-diagram)
2. [Tables Overview](#tables-overview)
3. [Detailed Table Schemas](#detailed-table-schemas)
4. [Indexes & Performance](#indexes--performance)
5. [Database Constraints](#database-constraints)
6. [Sample Queries](#sample-queries)

---

## ERD (Entity-Relationship Diagram)

```
┌─────────────────┐
│     users       │
│─────────────────│
│ id (PK)         │───┐
│ name            │   │
│ email (UQ)      │   │
│ password_hash   │   │
│ phone           │   │
│ role            │   │
│ created_at      │   │
└─────────────────┘   │
                      │
        ┌─────────────┴──────────────────┬──────────────┐
        │                                 │              │
        ▼                                 ▼              ▼
┌─────────────────┐           ┌─────────────────┐  ┌─────────────────┐
│   addresses     │           │  restaurants    │  │ delivery_drivers│
│─────────────────│           │─────────────────│  │─────────────────│
│ id (PK)         │           │ id (PK)         │  │ id (PK)         │
│ user_id (FK)    │           │ owner_id (FK)   │  │ user_id (FK, UQ)│
│ label           │           │ name            │  │ vehicle_type    │
│ street          │           │ description     │  │ license_plate   │
│ city            │           │ cuisine         │  │ status          │
│ postal_code     │           │ rating          │  │ current_lat     │
│ latitude        │           │ delivery_fee    │  │ current_lng     │
│ longitude       │           │ is_open         │  │ is_available    │
└─────────────────┘           │ phone           │  └─────────────────┘
                              │ address         │
                              └─────────────────┘
                                      │
                  ┌───────────────────┴───────────────────┐
                  │                                       │
                  ▼                                       ▼
        ┌─────────────────┐                   ┌─────────────────┐
        │ menu_categories │                   │     orders      │
        │─────────────────│                   │─────────────────│
        │ id (PK)         │                   │ id (PK)         │
        │ restaurant_id(FK)│                  │ user_id (FK)    │
        │ name            │                   │ restaurant_id(FK)│
        │ display_order   │                   │ driver_id (FK)  │
        └─────────────────┘                   │ status          │
                │                              │ subtotal        │
                │                              │ delivery_fee    │
                ▼                              │ tip_amount      │
        ┌─────────────────┐                   │ total_amount    │
        │   menu_items    │                   │ delivery_addr   │
        │─────────────────│                   │ delivery_lat    │
        │ id (PK)         │───┐               │ delivery_lng    │
        │ category_id (FK)│   │               │ created_at      │
        │ name            │   │               │ delivered_at    │
        │ description     │   │               └─────────────────┘
        │ price           │   │                       │
        │ image_url       │   │                       │
        │ is_available    │   │           ┌───────────┴──────────┐
        └─────────────────┘   │           │                      │
                              │           ▼                      ▼
                              │   ┌─────────────────┐    ┌─────────────────┐
                              │   │  order_items    │    │order_status_hist│
                              │   │─────────────────│    │─────────────────│
                              └──→│ id (PK)         │    │ id (PK)         │
                                  │ order_id (FK)   │    │ order_id (FK)   │
                                  │ menu_item_id(FK)│    │ status          │
                                  │ quantity        │    │ timestamp       │
                                  │ unit_price      │    │ notes           │
                                  │ subtotal        │    └─────────────────┘
                                  │ instructions    │
                                  └─────────────────┘

┌─────────────────┐                       ┌─────────────────┐
│payment_methods  │                       │   payments      │
│─────────────────│                       │─────────────────│
│ id (PK)         │                       │ id (PK)         │
│ user_id (FK)    │                       │ order_id (FK,UQ)│
│ type            │                       │ payment_meth(FK)│
│ provider        │                       │ amount          │
│ provider_id     │                       │ status          │
│ last_four       │                       │ transaction_id  │
│ is_default      │                       │ created_at      │
└─────────────────┘                       └─────────────────┘
        │
        └──────────────────────────────────────────┘
```

**Legend:**
- `PK` = Primary Key
- `FK` = Foreign Key
- `UQ` = Unique Constraint

---

## Tables Overview

| Table | Purpose | Records (Est.) |
|-------|---------|----------------|
| `users` | All user accounts (customers, drivers, owners) | 10K-100K |
| `addresses` | User delivery addresses | 20K-200K |
| `restaurants` | Restaurant profiles | 100-1K |
| `menu_categories` | Menu sections (Appetizers, Mains, etc.) | 500-5K |
| `menu_items` | Individual dishes | 5K-50K |
| `orders` | Order records | 100K-1M |
| `order_items` | Line items in orders | 300K-3M |
| `order_status_history` | Order state tracking | 500K-5M |
| `delivery_drivers` | Driver profiles | 100-1K |
| `payment_methods` | Saved payment methods | 15K-150K |
| `payments` | Payment transactions | 100K-1M |

---

## Detailed Table Schemas

### 1. users

**Purpose:** Store all user accounts (customers, drivers, restaurant owners, admins).

```sql
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY COMMENT 'UUID v4',
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL COMMENT 'bcrypt hash',
    phone VARCHAR(20) NOT NULL,
    role ENUM('customer', 'driver', 'restaurant_owner', 'admin') NOT NULL DEFAULT 'customer',
    email_verified_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT 'Soft delete',

    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Constraints:**
- Email must be unique
- Password must be bcrypt hashed (60 characters)
- Phone format: +[country][number]

---

### 2. addresses

**Purpose:** Store user delivery addresses with geolocation.

```sql
CREATE TABLE addresses (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    label VARCHAR(50) NOT NULL DEFAULT 'Home' COMMENT 'Home, Work, Other',
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'US' COMMENT 'ISO 3166-1 alpha-2',
    latitude DECIMAL(10, 8) NULL COMMENT 'For distance calculation',
    longitude DECIMAL(11, 8) NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    SPATIAL INDEX idx_coordinates (latitude, longitude) -- for geo queries
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Business Rules:**
- Only one default address per user
- Latitude: -90 to 90
- Longitude: -180 to 180

---

### 3. restaurants

**Purpose:** Restaurant profiles and metadata.

```sql
CREATE TABLE restaurants (
    id CHAR(36) PRIMARY KEY,
    owner_id CHAR(36) NOT NULL,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL UNIQUE COMMENT 'URL-friendly name',
    description TEXT,
    cuisine VARCHAR(50) NOT NULL COMMENT 'italian, chinese, mexican, etc.',
    rating DECIMAL(2, 1) NOT NULL DEFAULT 0.0 COMMENT '0.0 to 5.0',
    total_reviews INT NOT NULL DEFAULT 0,
    delivery_fee DECIMAL(8, 2) NOT NULL COMMENT 'Base delivery fee',
    min_order_amount DECIMAL(8, 2) NOT NULL DEFAULT 0.00,
    estimated_delivery_time INT NOT NULL COMMENT 'Minutes',
    is_open BOOLEAN NOT NULL DEFAULT TRUE,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    image_url VARCHAR(500),
    banner_url VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_owner_id (owner_id),
    INDEX idx_cuisine (cuisine),
    INDEX idx_rating (rating),
    INDEX idx_is_open (is_open),
    FULLTEXT INDEX idx_search (name, description, cuisine),
    SPATIAL INDEX idx_location (latitude, longitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 4. menu_categories

**Purpose:** Organize menu items into categories (Appetizers, Mains, Desserts).

```sql
CREATE TABLE menu_categories (
    id CHAR(36) PRIMARY KEY,
    restaurant_id CHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    display_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    INDEX idx_restaurant_id (restaurant_id),
    INDEX idx_display_order (display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 5. menu_items

**Purpose:** Individual dishes and products.

```sql
CREATE TABLE menu_items (
    id CHAR(36) PRIMARY KEY,
    category_id CHAR(36) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(8, 2) NOT NULL,
    image_url VARCHAR(500),
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    is_vegetarian BOOLEAN NOT NULL DEFAULT FALSE,
    is_vegan BOOLEAN NOT NULL DEFAULT FALSE,
    is_gluten_free BOOLEAN NOT NULL DEFAULT FALSE,
    calories INT NULL,
    preparation_time INT NULL COMMENT 'Minutes',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (category_id) REFERENCES menu_categories(id) ON DELETE CASCADE,
    INDEX idx_category_id (category_id),
    INDEX idx_is_available (is_available),
    FULLTEXT INDEX idx_search (name, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 6. orders

**Purpose:** Main order records.

```sql
CREATE TABLE orders (
    id CHAR(36) PRIMARY KEY,
    order_number VARCHAR(20) NOT NULL UNIQUE COMMENT 'Human-readable: ORD-20250101-0001',
    user_id CHAR(36) NOT NULL,
    restaurant_id CHAR(36) NOT NULL,
    driver_id CHAR(36) NULL,
    status ENUM(
        'pending',
        'confirmed',
        'preparing',
        'ready',
        'picked_up',
        'delivering',
        'delivered',
        'cancelled'
    ) NOT NULL DEFAULT 'pending',
    subtotal DECIMAL(10, 2) NOT NULL COMMENT 'Sum of items',
    delivery_fee DECIMAL(8, 2) NOT NULL,
    tip_amount DECIMAL(8, 2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(8, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    delivery_address TEXT NOT NULL,
    delivery_latitude DECIMAL(10, 8) NOT NULL,
    delivery_longitude DECIMAL(11, 8) NOT NULL,
    estimated_delivery_time TIMESTAMP NULL,
    confirmed_at TIMESTAMP NULL,
    preparing_at TIMESTAMP NULL,
    ready_at TIMESTAMP NULL,
    picked_up_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    cancelled_at TIMESTAMP NULL,
    cancellation_reason TEXT NULL,
    special_instructions TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE RESTRICT,
    FOREIGN KEY (driver_id) REFERENCES delivery_drivers(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_restaurant_id (restaurant_id),
    INDEX idx_driver_id (driver_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_order_number (order_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Business Rules:**
- `total_amount = subtotal + delivery_fee + tip_amount + tax_amount`
- Status transitions must be sequential
- Cannot cancel after `picked_up` status

---

### 7. order_items

**Purpose:** Line items within an order.

```sql
CREATE TABLE order_items (
    id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) NOT NULL,
    menu_item_id CHAR(36) NOT NULL,
    menu_item_name VARCHAR(200) NOT NULL COMMENT 'Snapshot (in case item is deleted)',
    quantity INT NOT NULL,
    unit_price DECIMAL(8, 2) NOT NULL COMMENT 'Price at time of order',
    subtotal DECIMAL(10, 2) NOT NULL COMMENT 'quantity * unit_price',
    special_instructions TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE RESTRICT,
    INDEX idx_order_id (order_id),
    INDEX idx_menu_item_id (menu_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Why snapshot menu_item_name?**
If a restaurant deletes or renames a menu item, we still need to show the original order details.

---

### 8. order_status_history

**Purpose:** Track order status changes with timestamps (audit trail).

```sql
CREATE TABLE order_status_history (
    id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) NOT NULL,
    status ENUM(
        'pending',
        'confirmed',
        'preparing',
        'ready',
        'picked_up',
        'delivering',
        'delivered',
        'cancelled'
    ) NOT NULL,
    changed_by CHAR(36) NULL COMMENT 'user_id who triggered the change',
    notes TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_order_id (order_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 9. delivery_drivers

**Purpose:** Delivery driver profiles and real-time location.

```sql
CREATE TABLE delivery_drivers (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL UNIQUE,
    vehicle_type ENUM('bike', 'scooter', 'car', 'motorcycle') NOT NULL,
    vehicle_model VARCHAR(100) NULL,
    license_plate VARCHAR(20) NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('offline', 'available', 'busy') NOT NULL DEFAULT 'offline',
    current_latitude DECIMAL(10, 8) NULL,
    current_longitude DECIMAL(11, 8) NULL,
    last_location_update TIMESTAMP NULL,
    rating DECIMAL(2, 1) NOT NULL DEFAULT 0.0,
    total_deliveries INT NOT NULL DEFAULT 0,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,
    approved_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    SPATIAL INDEX idx_location (current_latitude, current_longitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### 10. payment_methods

**Purpose:** Saved payment methods (cards, PayPal).

```sql
CREATE TABLE payment_methods (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    type ENUM('card', 'paypal') NOT NULL,
    provider ENUM('stripe', 'paypal') NOT NULL,
    provider_payment_method_id VARCHAR(255) NOT NULL COMMENT 'Stripe/PayPal ID',
    last_four VARCHAR(4) NULL COMMENT 'Last 4 digits (cards only)',
    brand VARCHAR(20) NULL COMMENT 'Visa, Mastercard, etc.',
    expiry_month INT NULL,
    expiry_year INT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_default (is_default)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Security:**
- Never store full card numbers
- Never store CVV
- Use payment provider tokens only

---

### 11. payments

**Purpose:** Payment transaction records.

```sql
CREATE TABLE payments (
    id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) NOT NULL UNIQUE COMMENT 'One payment per order',
    payment_method_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    provider_transaction_id VARCHAR(255) NULL COMMENT 'Stripe charge ID',
    failure_reason TEXT NULL,
    refund_amount DECIMAL(10, 2) NULL,
    refunded_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE RESTRICT,
    INDEX idx_order_id (order_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## Indexes & Performance

### Primary Indexes (Already Defined)

1. **Foreign Key Indexes:** All FK columns indexed for JOIN performance
2. **Status Indexes:** Order status, driver status (frequently filtered)
3. **Timestamp Indexes:** `created_at` for sorting/pagination
4. **Search Indexes:** FULLTEXT on restaurant/menu item names

### Composite Indexes (Add Later)

```sql
-- Frequently queried together
CREATE INDEX idx_user_status ON orders(user_id, status);
CREATE INDEX idx_restaurant_available ON menu_items(category_id, is_available);
CREATE INDEX idx_driver_status_location ON delivery_drivers(status, current_latitude, current_longitude);
```

### Geospatial Queries

```sql
-- Find restaurants within 5km radius
SELECT id, name,
    ST_Distance_Sphere(
        POINT(longitude, latitude),
        POINT(:user_lng, :user_lat)
    ) AS distance_meters
FROM restaurants
WHERE is_open = TRUE
HAVING distance_meters < 5000
ORDER BY distance_meters
LIMIT 20;
```

---

## Database Constraints

### Referential Integrity

✅ **Cascade Deletes:**
- Delete user → Delete addresses
- Delete restaurant → Delete menu categories → Delete menu items
- Delete order → Delete order items

❌ **Restrict Deletes:**
- Cannot delete user if they have orders
- Cannot delete menu item if it's in an order
- Cannot delete restaurant if it has orders

### Check Constraints (MySQL 8.0+)

```sql
ALTER TABLE restaurants
ADD CONSTRAINT chk_rating CHECK (rating >= 0 AND rating <= 5);

ALTER TABLE orders
ADD CONSTRAINT chk_amounts CHECK (total_amount >= 0);

ALTER TABLE addresses
ADD CONSTRAINT chk_latitude CHECK (latitude BETWEEN -90 AND 90);
ALTER TABLE addresses
ADD CONSTRAINT chk_longitude CHECK (longitude BETWEEN -180 AND 180);
```

---

## Sample Queries

### 1. Get User's Recent Orders

```sql
SELECT
    o.id,
    o.order_number,
    o.status,
    o.total_amount,
    o.created_at,
    r.name AS restaurant_name,
    r.image_url AS restaurant_image
FROM orders o
INNER JOIN restaurants r ON o.restaurant_id = r.id
WHERE o.user_id = :user_id
ORDER BY o.created_at DESC
LIMIT 10;
```

### 2. Get Restaurant Menu with Categories

```sql
SELECT
    c.id AS category_id,
    c.name AS category_name,
    m.id AS item_id,
    m.name AS item_name,
    m.description,
    m.price,
    m.image_url,
    m.is_available
FROM menu_categories c
INNER JOIN menu_items m ON c.id = m.category_id
WHERE c.restaurant_id = :restaurant_id
  AND c.is_active = TRUE
ORDER BY c.display_order, m.name;
```

### 3. Find Nearest Available Drivers

```sql
SELECT
    d.id,
    u.name,
    u.phone,
    d.vehicle_type,
    ST_Distance_Sphere(
        POINT(d.current_longitude, d.current_latitude),
        POINT(:order_lng, :order_lat)
    ) AS distance_meters
FROM delivery_drivers d
INNER JOIN users u ON d.user_id = u.id
WHERE d.status = 'available'
  AND d.is_approved = TRUE
HAVING distance_meters < 10000
ORDER BY distance_meters
LIMIT 5;
```

### 4. Calculate Restaurant Rating

```sql
-- This would be run periodically (cron job) to update restaurant ratings
UPDATE restaurants r
SET
    rating = (
        SELECT AVG(rating)
        FROM order_reviews
        WHERE restaurant_id = r.id
    ),
    total_reviews = (
        SELECT COUNT(*)
        FROM order_reviews
        WHERE restaurant_id = r.id
    );
```

---

## Database Migrations

Migrations will be stored in `/backend/database/migrations/` and executed in sequential order.

**Example Migration File:**

```sql
-- /backend/database/migrations/001_create_users_table.sql
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY,
    -- ... (full schema)
);
```

**Migration Runner:** Simple PHP script or use a library like Phinx.

---

## Next Steps

1. ✅ Create migration files (see `/backend/database/migrations/`)
2. ✅ Add seed data for development
3. ✅ Implement repository pattern
4. ✅ Add database backup scripts

---

## Security Considerations

### 1. Password Storage
- ✅ Use `password_hash()` with bcrypt
- ✅ Never store plain text passwords
- ✅ Minimum 60 characters for hash storage

### 2. SQL Injection Prevention
- ✅ Use prepared statements (PDO)
- ✅ Never concatenate user input into queries
- ✅ Validate/sanitize all inputs

### 3. Data Privacy
- ✅ Soft delete sensitive records (set `deleted_at`)
- ✅ Log access to sensitive data
- ✅ Encrypt payment provider tokens

### 4. Performance
- ✅ Use indexes on frequently queried columns
- ✅ Partition large tables (orders, payments)
- ✅ Regular ANALYZE TABLE for query optimization

---

## References

- [MySQL 8.0 Documentation](https://dev.mysql.com/doc/refman/8.0/en/)
- [Database Normalization](https://en.wikipedia.org/wiki/Database_normalization)
- [MySQL Spatial Data Types](https://dev.mysql.com/doc/refman/8.0/en/spatial-types.html)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

---

**Last Updated:** 2025-12-03
**Sprint:** Sprint 0 - Foundation & Learning
**Status:** ✅ Complete
