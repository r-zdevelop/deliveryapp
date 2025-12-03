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