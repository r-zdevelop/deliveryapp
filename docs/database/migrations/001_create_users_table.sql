-- Migration: Create users table
-- Purpose: Store all user accounts (customers, drivers, restaurant owners, admins)
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User accounts for customers, drivers, restaurant owners, and admins';
