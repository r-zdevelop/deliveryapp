<?php
declare(strict_types=1);

/**
 * Delivery App - Entry Point
 * Purpose: Test Docker setup and display phpinfo
 */

// Display PHP version and loaded extensions
echo "<h1>=€ Delivery App - Backend Running</h1>";
echo "<p><strong>PHP Version:</strong> " . phpversion() . "</p>";

// Test MySQL Extension
echo "<h2>Database (MySQL)</h2>";
if (extension_loaded('pdo_mysql')) {
    echo " PDO MySQL extension loaded<br>";

    try {
        $pdo = new PDO(
            'mysql:host=' . getenv('DB_HOST') . ';port=' . getenv('DB_PORT') . ';dbname=' . getenv('DB_NAME'),
            getenv('DB_USER'),
            getenv('DB_PASSWORD'),
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
        echo " Database connection successful<br>";
        echo "Database: " . getenv('DB_NAME') . "<br>";
    } catch (PDOException $e) {
        echo "L Database connection failed: " . $e->getMessage() . "<br>";
    }
} else {
    echo "L PDO MySQL extension not loaded<br>";
}

// Test Redis Extension
echo "<h2>Cache (Redis)</h2>";
if (extension_loaded('redis')) {
    echo " Redis extension loaded<br>";

    try {
        $redis = new Redis();
        $redis->connect(getenv('REDIS_HOST'), (int)getenv('REDIS_PORT'));
        $redis->auth('redis_password_change_me');
        $redis->set('test_key', 'Hello from Delivery App!');
        $value = $redis->get('test_key');
        echo " Redis connection successful<br>";
        echo "Test value: {$value}<br>";
    } catch (Exception $e) {
        echo "L Redis connection failed: " . $e->getMessage() . "<br>";
    }
} else {
    echo "L Redis extension not loaded<br>";
}

// Loaded Extensions
echo "<h2>Loaded PHP Extensions</h2>";
$extensions = get_loaded_extensions();
sort($extensions);
echo "<ul>";
foreach ($extensions as $ext) {
    echo "<li>{$ext}</li>";
}
echo "</ul>";

// Display full phpinfo (comment out for production)
echo "<hr>";
echo "<details><summary>Click to view full phpinfo()</summary>";
phpinfo();
echo "</details>";
