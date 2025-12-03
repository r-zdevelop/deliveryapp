-- Seed: Development sample data
-- Purpose: Populate database with test data for development
-- Sprint: Sprint 0 - Foundation & Learning
-- Created: 2025-12-03

-- ==================== USERS ====================

INSERT INTO users (id, name, email, password_hash, phone, role, created_at) VALUES
-- Customers (password: "password123")
('550e8400-e29b-41d4-a716-446655440001', 'John Doe', 'john.doe@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567890', 'customer', NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'Jane Smith', 'jane.smith@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567891', 'customer', NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'Mike Johnson', 'mike.j@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567892', 'customer', NOW()),

-- Restaurant Owners
('550e8400-e29b-41d4-a716-446655440004', 'Mario Rossi', 'mario.rossi@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567893', 'restaurant_owner', NOW()),
('550e8400-e29b-41d4-a716-446655440005', 'Chen Wei', 'chen.wei@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567894', 'restaurant_owner', NOW()),
('550e8400-e29b-41d4-a716-446655440006', 'Carlos Garcia', 'carlos.garcia@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567895', 'restaurant_owner', NOW()),

-- Delivery Drivers
('550e8400-e29b-41d4-a716-446655440007', 'David Miller', 'david.driver@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567896', 'driver', NOW()),
('550e8400-e29b-41d4-a716-446655440008', 'Sarah Wilson', 'sarah.driver@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567897', 'driver', NOW()),

-- Admin
('550e8400-e29b-41d4-a716-446655440009', 'Admin User', 'admin@deliveryapp.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1234567898', 'admin', NOW());

-- ==================== ADDRESSES ====================

INSERT INTO addresses (id, user_id, label, street, city, state, postal_code, country, latitude, longitude, is_default) VALUES
-- John Doe's addresses
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Home', '123 Main Street', 'San Francisco', 'CA', '94102', 'US', 37.7749, -122.4194, TRUE),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Work', '456 Market Street', 'San Francisco', 'CA', '94103', 'US', 37.7858, -122.4064, FALSE),

-- Jane Smith's address
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Home', '789 Oak Avenue', 'San Francisco', 'CA', '94104', 'US', 37.7900, -122.4000, TRUE);

-- ==================== RESTAURANTS ====================

INSERT INTO restaurants (id, owner_id, name, slug, description, cuisine, rating, total_reviews, delivery_fee, min_order_amount, estimated_delivery_time, is_open, phone, email, address, latitude, longitude, image_url) VALUES
-- Italian Restaurant
('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'La Trattoria', 'la-trattoria', 'Authentic Italian cuisine with traditional recipes', 'italian', 4.5, 250, 5.99, 15.00, 30, TRUE, '+14155551001', 'info@latrattoria.com', '100 Columbus Avenue, San Francisco, CA 94133', 37.7983, -122.4077, 'https://example.com/restaurants/trattoria.jpg'),

-- Chinese Restaurant
('770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', 'Golden Dragon', 'golden-dragon', 'Traditional Cantonese and Szechuan dishes', 'chinese', 4.3, 180, 4.99, 20.00, 35, TRUE, '+14155551002', 'info@goldendragon.com', '200 Grant Avenue, San Francisco, CA 94108', 37.7909, -122.4056, 'https://example.com/restaurants/dragon.jpg'),

-- Mexican Restaurant
('770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', 'Taco Fiesta', 'taco-fiesta', 'Fresh Mexican tacos, burritos, and more', 'mexican', 4.7, 320, 3.99, 10.00, 25, TRUE, '+14155551003', 'info@tacofiesta.com', '300 Mission Street, San Francisco, CA 94105', 37.7897, -122.3972, 'https://example.com/restaurants/taco.jpg');

-- ==================== MENU CATEGORIES ====================

-- La Trattoria categories
INSERT INTO menu_categories (id, restaurant_id, name, display_order, is_active) VALUES
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 'Appetizers', 1, TRUE),
('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', 'Pasta', 2, TRUE),
('880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440001', 'Pizza', 3, TRUE),
('880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440001', 'Desserts', 4, TRUE);

-- Golden Dragon categories
INSERT INTO menu_categories (id, restaurant_id, name, display_order, is_active) VALUES
('880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440002', 'Dim Sum', 1, TRUE),
('880e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440002', 'Main Dishes', 2, TRUE),
('880e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440002', 'Noodles', 3, TRUE);

-- Taco Fiesta categories
INSERT INTO menu_categories (id, restaurant_id, name, display_order, is_active) VALUES
('880e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440003', 'Tacos', 1, TRUE),
('880e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440003', 'Burritos', 2, TRUE),
('880e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440003', 'Sides', 3, TRUE);

-- ==================== MENU ITEMS ====================

-- La Trattoria - Appetizers
INSERT INTO menu_items (id, category_id, name, description, price, is_available, is_vegetarian, is_vegan, is_gluten_free, calories) VALUES
('990e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 'Bruschetta', 'Toasted bread with tomatoes, basil, and olive oil', 8.99, TRUE, TRUE, TRUE, FALSE, 150),
('990e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440001', 'Caprese Salad', 'Fresh mozzarella, tomatoes, and basil', 10.99, TRUE, TRUE, FALSE, TRUE, 200);

-- La Trattoria - Pasta
INSERT INTO menu_items (id, category_id, name, description, price, is_available, is_vegetarian, is_vegan, is_gluten_free, calories) VALUES
('990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002', 'Spaghetti Carbonara', 'Classic Roman pasta with eggs, cheese, and guanciale', 16.99, TRUE, FALSE, FALSE, FALSE, 650),
('990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440002', 'Penne Arrabbiata', 'Spicy tomato sauce with garlic and chili', 14.99, TRUE, TRUE, TRUE, FALSE, 450);

-- La Trattoria - Pizza
INSERT INTO menu_items (id, category_id, name, description, price, is_available, is_vegetarian, is_vegan, is_gluten_free, calories) VALUES
('990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440003', 'Margherita Pizza', 'Tomato, mozzarella, and fresh basil', 13.99, TRUE, TRUE, FALSE, FALSE, 800),
('990e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440003', 'Pepperoni Pizza', 'Tomato, mozzarella, and pepperoni', 15.99, TRUE, FALSE, FALSE, FALSE, 950);

-- Golden Dragon - Dim Sum
INSERT INTO menu_items (id, category_id, name, description, price, is_available, is_vegetarian, is_vegan, is_gluten_free, calories) VALUES
('990e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440005', 'Pork Dumplings', 'Steamed dumplings with pork filling (6 pieces)', 9.99, TRUE, FALSE, FALSE, FALSE, 300),
('990e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440005', 'Vegetable Spring Rolls', 'Crispy spring rolls with vegetables (4 pieces)', 7.99, TRUE, TRUE, TRUE, FALSE, 250);

-- Golden Dragon - Main Dishes
INSERT INTO menu_items (id, category_id, name, description, price, is_available, is_vegetarian, is_vegan, is_gluten_free, calories) VALUES
('990e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440006', 'Kung Pao Chicken', 'Spicy chicken with peanuts and vegetables', 14.99, TRUE, FALSE, FALSE, FALSE, 550),
('990e8400-e29b-41d4-a716-446655440010', '880e8400-e29b-41d4-a716-446655440006', 'Mapo Tofu', 'Spicy tofu in fermented bean sauce', 12.99, TRUE, TRUE, FALSE, FALSE, 400);

-- Taco Fiesta - Tacos
INSERT INTO menu_items (id, category_id, name, description, price, is_available, is_vegetarian, is_vegan, is_gluten_free, calories) VALUES
('990e8400-e29b-41d4-a716-446655440011', '880e8400-e29b-41d4-a716-446655440008', 'Carnitas Tacos', 'Slow-cooked pork with onions and cilantro (3 tacos)', 11.99, TRUE, FALSE, FALSE, TRUE, 450),
('990e8400-e29b-41d4-a716-446655440012', '880e8400-e29b-41d4-a716-446655440008', 'Vegetarian Tacos', 'Grilled vegetables with guacamole (3 tacos)', 9.99, TRUE, TRUE, TRUE, TRUE, 350);

-- Taco Fiesta - Burritos
INSERT INTO menu_items (id, category_id, name, description, price, is_available, is_vegetarian, is_vegan, is_gluten_free, calories) VALUES
('990e8400-e29b-41d4-a716-446655440013', '880e8400-e29b-41d4-a716-446655440009', 'Chicken Burrito', 'Grilled chicken with rice, beans, and cheese', 13.99, TRUE, FALSE, FALSE, FALSE, 700),
('990e8400-e29b-41d4-a716-446655440014', '880e8400-e29b-41d4-a716-446655440009', 'Bean & Rice Burrito', 'Black beans, rice, salsa, and guacamole', 10.99, TRUE, TRUE, TRUE, FALSE, 550);

-- ==================== DELIVERY DRIVERS ====================

INSERT INTO delivery_drivers (id, user_id, vehicle_type, vehicle_model, license_plate, license_number, status, current_latitude, current_longitude, rating, total_deliveries, is_approved, approved_at) VALUES
('aa0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440007', 'bike', 'Trek FX 3', 'N/A', 'DRV123456', 'available', 37.7850, -122.4100, 4.8, 120, TRUE, NOW()),
('aa0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440008', 'scooter', 'Vespa Primavera', 'ABC-1234', 'DRV789012', 'available', 37.7900, -122.4050, 4.6, 95, TRUE, NOW());

-- ==================== SAMPLE ORDER (for testing) ====================

INSERT INTO orders (id, order_number, user_id, restaurant_id, driver_id, status, subtotal, delivery_fee, tip_amount, tax_amount, total_amount, delivery_address, delivery_latitude, delivery_longitude, estimated_delivery_time, created_at) VALUES
('bb0e8400-e29b-41d4-a716-446655440001', 'ORD-20251203-0001', '550e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', 'delivering', 30.98, 5.99, 5.00, 3.72, 45.69, '123 Main Street, San Francisco, CA 94102', 37.7749, -122.4194, DATE_ADD(NOW(), INTERVAL 20 MINUTE), NOW());

INSERT INTO order_items (id, order_id, menu_item_id, menu_item_name, quantity, unit_price, subtotal) VALUES
('cc0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440003', 'Spaghetti Carbonara', 1, 16.99, 16.99),
('cc0e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440005', 'Margherita Pizza', 1, 13.99, 13.99);

INSERT INTO order_status_history (id, order_id, status, changed_by, created_at) VALUES
('dd0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', 'pending', '550e8400-e29b-41d4-a716-446655440001', DATE_SUB(NOW(), INTERVAL 30 MINUTE)),
('dd0e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440001', 'confirmed', '550e8400-e29b-41d4-a716-446655440004', DATE_SUB(NOW(), INTERVAL 25 MINUTE)),
('dd0e8400-e29b-41d4-a716-446655440003', 'bb0e8400-e29b-41d4-a716-446655440001', 'preparing', '550e8400-e29b-41d4-a716-446655440004', DATE_SUB(NOW(), INTERVAL 20 MINUTE)),
('dd0e8400-e29b-41d4-a716-446655440004', 'bb0e8400-e29b-41d4-a716-446655440001', 'ready', '550e8400-e29b-41d4-a716-446655440004', DATE_SUB(NOW(), INTERVAL 10 MINUTE)),
('dd0e8400-e29b-41d4-a716-446655440005', 'bb0e8400-e29b-41d4-a716-446655440001', 'picked_up', '550e8400-e29b-41d4-a716-446655440007', DATE_SUB(NOW(), INTERVAL 5 MINUTE)),
('dd0e8400-e29b-41d4-a716-446655440006', 'bb0e8400-e29b-41d4-a716-446655440001', 'delivering', '550e8400-e29b-41d4-a716-446655440007', NOW());

-- ==================== PAYMENT METHOD ====================

INSERT INTO payment_methods (id, user_id, type, provider, provider_payment_method_id, last_four, brand, is_default) VALUES
('ee0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'card', 'stripe', 'pm_fake_visa_test', '4242', 'Visa', TRUE);

-- ==================== PAYMENT ====================

INSERT INTO payments (id, order_id, payment_method_id, amount, status, provider_transaction_id, created_at) VALUES
('ff0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', 'ee0e8400-e29b-41d4-a716-446655440001', 45.69, 'completed', 'ch_fake_stripe_test_123', NOW());

-- ==================== VERIFICATION ====================

-- Verify counts
SELECT 'Users' AS table_name, COUNT(*) AS count FROM users
UNION ALL
SELECT 'Addresses', COUNT(*) FROM addresses
UNION ALL
SELECT 'Restaurants', COUNT(*) FROM restaurants
UNION ALL
SELECT 'Menu Categories', COUNT(*) FROM menu_categories
UNION ALL
SELECT 'Menu Items', COUNT(*) FROM menu_items
UNION ALL
SELECT 'Delivery Drivers', COUNT(*) FROM delivery_drivers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Order Status History', COUNT(*) FROM order_status_history
UNION ALL
SELECT 'Payment Methods', COUNT(*) FROM payment_methods
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments;
