-- Migration: Create orders table
-- Purpose: Main order records
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

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
    INDEX idx_order_number (order_number),

    CONSTRAINT chk_total_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_amounts CHECK (subtotal >= 0 AND delivery_fee >= 0 AND tip_amount >= 0 AND tax_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Main order records with status tracking';
