-- Migration: Create restaurants table
-- Purpose: Restaurant profiles and metadata
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

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
    INDEX idx_location (latitude, longitude),
    FULLTEXT INDEX idx_search (name, description, cuisine),

    CONSTRAINT chk_rating CHECK (rating >= 0 AND rating <= 5),
    CONSTRAINT chk_delivery_fee CHECK (delivery_fee >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Restaurant profiles and metadata';
