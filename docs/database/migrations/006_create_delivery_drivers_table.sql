-- Migration: Create delivery_drivers table
-- Purpose: Delivery driver profiles and real-time location
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

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
    INDEX idx_location (current_latitude, current_longitude),

    CONSTRAINT chk_driver_rating CHECK (rating >= 0 AND rating <= 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Delivery driver profiles and real-time location tracking';
