# Database Migrations

**Purpose:** Sequential database schema migrations for the Delivery App.

**Sprint:** Sprint 0 - Foundation & Learning

---

## Migration Order

Migrations must be executed in sequential order:

1. `001_create_users_table.sql` - Base user accounts
2. `002_create_addresses_table.sql` - User addresses (depends on users)
3. `003_create_restaurants_table.sql` - Restaurant profiles (depends on users)
4. `004_create_menu_categories_table.sql` - Menu categories (depends on restaurants)
5. `005_create_menu_items_table.sql` - Menu items (depends on menu_categories)
6. `006_create_delivery_drivers_table.sql` - Driver profiles (depends on users)
7. `007_create_orders_table.sql` - Orders (depends on users, restaurants, drivers)
8. `008_create_order_items_table.sql` - Order line items (depends on orders, menu_items)
9. `009_create_order_status_history_table.sql` - Order audit trail (depends on orders)
10. `010_create_payment_methods_table.sql` - Saved payment methods (depends on users)
11. `011_create_payments_table.sql` - Payment transactions (depends on orders, payment_methods)

---

## Running Migrations

### Option 1: Manual Execution

```bash
# Connect to MySQL container
docker compose exec database mysql -u delivery_user -p deliveryapp

# Execute each migration in order
SOURCE /path/to/001_create_users_table.sql;
SOURCE /path/to/002_create_addresses_table.sql;
# ... etc
```

### Option 2: Run All Migrations (Bash Script)

```bash
#!/bin/bash
# migrate.sh - Run all database migrations

MIGRATIONS_DIR="./docs/database/migrations"
DB_CONTAINER="delivery-db"
DB_NAME="deliveryapp"
DB_USER="delivery_user"
DB_PASS="secure_password_change_me"

for migration in $(ls -1 $MIGRATIONS_DIR/*.sql | sort); do
    echo "Running migration: $(basename $migration)"
    docker compose exec -T database mysql \
        -u $DB_USER \
        -p$DB_PASS \
        $DB_NAME < $migration

    if [ $? -eq 0 ]; then
        echo "✅ $(basename $migration) completed successfully"
    else
        echo "❌ $(basename $migration) failed"
        exit 1
    fi
done

echo "✅ All migrations completed successfully"
```

Make executable and run:
```bash
chmod +x migrate.sh
./migrate.sh
```

### Option 3: Using Docker Compose Volume Mount

Add to `docker-compose.yml`:

```yaml
services:
  database:
    volumes:
      - ./docs/database/migrations:/docker-entrypoint-initdb.d:ro
```

This will automatically run migrations when the container is first created.

---

## Rollback

To rollback migrations, drop tables in reverse order:

```sql
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS payment_methods;
DROP TABLE IF EXISTS order_status_history;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS delivery_drivers;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS menu_categories;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;
```

---

## Verifying Migrations

```sql
-- Show all tables
SHOW TABLES;

-- Check table structure
DESCRIBE users;
DESCRIBE orders;

-- Verify foreign keys
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'deliveryapp'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Verify indexes
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'deliveryapp'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
```

---

## Future Migrations

When adding new migrations:

1. **Naming Convention:** `XXX_description.sql` (e.g., `012_add_user_avatar.sql`)
2. **Comments:** Include purpose, sprint, and date
3. **Idempotency:** Use `CREATE TABLE IF NOT EXISTS` when possible
4. **Data Migrations:** Separate data migrations from schema migrations
5. **Testing:** Test on local database before production

---

## Moving to Backend Directory

Once you fix the permissions issue, move migrations to the backend:

```bash
# Create backend directory
mkdir -p backend/database/migrations

# Copy migrations
cp docs/database/migrations/*.sql backend/database/migrations/

# Update migration script to point to new location
```

---

**Last Updated:** 2025-12-03
**Sprint:** Sprint 0 - Foundation & Learning
**Status:** ✅ Complete
