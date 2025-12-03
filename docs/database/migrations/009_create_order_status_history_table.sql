-- Migration: Create order_status_history table
-- Purpose: Track order status changes with timestamps (audit trail)
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Audit trail for order status changes';
