-- Migration: Create order_items table
-- Purpose: Line items within an order
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

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
    INDEX idx_menu_item_id (menu_item_id),

    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_unit_price CHECK (unit_price >= 0),
    CONSTRAINT chk_subtotal CHECK (subtotal >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Line items (products) within orders';
