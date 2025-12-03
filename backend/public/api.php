<?php
declare(strict_types=1);

/**
 * Delivery App - Hello World API Endpoint
 * Purpose: Test REST API functionality
 * Sprint: Sprint 0 - Local Development Setup
 *
 * Usage: GET http://localhost:8080/api.php
 */

header('Content-Type: application/json; charset=utf-8');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');

// CORS headers for development (restrict in production)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

try {
    $response = [
        'success' => true,
        'message' => 'Hello World from Delivery App API! 🚀',
        'data' => [
            'app_name' => 'Delivery App',
            'version' => '1.0.0',
            'environment' => getenv('APP_ENV') ?: 'development',
            'php_version' => phpversion(),
            'timestamp' => date('c'),
            'endpoints' => [
                'health' => '/health',
                'api_docs' => '/docs',
                'users' => '/api/users',
                'restaurants' => '/api/restaurants',
                'orders' => '/api/orders'
            ]
        ],
        'status' => [
            'database' => checkDatabase(),
            'cache' => checkCache()
        ]
    ];

    http_response_code(200);
    echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Internal Server Error',
        'error' => getenv('APP_DEBUG') === 'true' ? $e->getMessage() : 'An error occurred'
    ], JSON_PRETTY_PRINT);
}

/**
 * Check database connectivity
 */
function checkDatabase(): string
{
    if (!extension_loaded('pdo_mysql')) {
        return 'unavailable';
    }

    try {
        $pdo = new PDO(
            sprintf(
                'mysql:host=%s;port=%s;dbname=%s',
                getenv('DB_HOST'),
                getenv('DB_PORT'),
                getenv('DB_NAME')
            ),
            getenv('DB_USER'),
            getenv('DB_PASSWORD'),
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_TIMEOUT => 2
            ]
        );
        return 'connected';
    } catch (PDOException $e) {
        return 'disconnected';
    }
}

/**
 * Check Redis connectivity
 */
function checkCache(): string
{
    if (!extension_loaded('redis')) {
        return 'unavailable';
    }

    try {
        $redis = new Redis();
        $redis->connect(getenv('REDIS_HOST'), (int)getenv('REDIS_PORT'), 2);
        $redis->auth('redis_password_change_me');
        $redis->ping();
        return 'connected';
    } catch (Exception $e) {
        return 'disconnected';
    }
}
