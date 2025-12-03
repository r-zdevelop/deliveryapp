#!/bin/bash

# Root folder
mkdir -p deliveryapp
cd deliveryapp

###############
# BACKEND
###############
mkdir -p backend/src/Domain/User/Entity
mkdir -p backend/src/Domain/User/ValueObject
mkdir -p backend/src/Domain/User/Repository
mkdir -p backend/src/Domain/Restaurant
mkdir -p backend/src/Domain/Order
mkdir -p backend/src/Domain/Delivery
mkdir -p backend/src/Domain/Payment

mkdir -p backend/src/Application/User/CreateUser
mkdir -p backend/src/Application/User/AuthenticateUser
mkdir -p backend/src/Application/Order/PlaceOrder
mkdir -p backend/src/Application/Order/TrackOrder
mkdir -p backend/src/Application/Restaurant/ManageMenu

mkdir -p backend/src/Infrastructure/Persistence/MySQL
mkdir -p backend/src/Infrastructure/Http
mkdir -p backend/src/Infrastructure/Security
mkdir -p backend/src/Infrastructure/Payment
mkdir -p backend/src/Infrastructure/Notification

mkdir -p backend/src/Presentation/Controllers

mkdir -p backend/config
mkdir -p backend/public
mkdir -p backend/tests

# Backend empty files
touch backend/src/Domain/User/Entity/User.php
touch backend/src/Domain/User/ValueObject/UserId.php
touch backend/src/Domain/User/ValueObject/Email.php
touch backend/src/Domain/User/ValueObject/Password.php
touch backend/src/Domain/User/Repository/UserRepositoryInterface.php

touch backend/src/Infrastructure/Http/Router.php
touch backend/src/Infrastructure/Http/Request.php
touch backend/src/Infrastructure/Http/Response.php

touch backend/src/Infrastructure/Security/JwtManager.php
touch backend/src/Infrastructure/Security/PasswordHasher.php

touch backend/src/Infrastructure/Payment/StripeGateway.php

touch backend/src/Infrastructure/Notification/EmailService.php
touch backend/src/Infrastructure/Notification/PushNotification.php

touch backend/src/Presentation/Controllers/UserController.php
touch backend/src/Presentation/Controllers/OrderController.php
touch backend/src/Presentation/Controllers/RestaurantController.php

touch backend/config/database.php
touch backend/config/routes.php
touch backend/config/container.php
touch backend/config/security.php
touch backend/public/index.php

###############
# MOBILE
###############
mkdir -p mobile/lib/features/auth
mkdir -p mobile/lib/features/restaurants
mkdir -p mobile/lib/features/orders
mkdir -p mobile/lib/features/delivery
mkdir -p mobile/lib/core/api
mkdir -p mobile/lib/core/state
mkdir -p mobile/lib/core/routing

touch mobile/lib/main.dart

###############
# DOCKER
###############
mkdir -p docker/php
mkdir -p docker/apache
mkdir -p docker/nginx

touch docker/php/Dockerfile
touch docker/php/php.ini
touch docker/apache/delivery-app.conf

###############
# ROOT FILES
###############
touch docker-compose.yml
touch docker-compose.prod.yml
touch deploy.sh
touch rollback.sh
touch .env.example

echo "Project structure created successfully!"
