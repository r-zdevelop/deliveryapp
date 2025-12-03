-- Migration: Create payment_methods table
-- Purpose: Saved payment methods (cards, PayPal)
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

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
    INDEX idx_is_default (is_default),

    CONSTRAINT chk_expiry_month CHECK (expiry_month BETWEEN 1 AND 12)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User saved payment methods (tokenized, PCI-compliant)';
