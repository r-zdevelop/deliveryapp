-- Migration: Create payments table
-- Purpose: Payment transaction records
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

CREATE TABLE payments (
    id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) NOT NULL UNIQUE COMMENT 'One payment per order',
    payment_method_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    provider_transaction_id VARCHAR(255) NULL COMMENT 'Stripe charge ID / PayPal transaction ID',
    failure_reason TEXT NULL,
    refund_amount DECIMAL(10, 2) NULL,
    refunded_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE RESTRICT,
    INDEX idx_order_id (order_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),

    CONSTRAINT chk_amount CHECK (amount >= 0),
    CONSTRAINT chk_refund_amount CHECK (refund_amount IS NULL OR refund_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Payment transaction records (Stripe/PayPal)';
