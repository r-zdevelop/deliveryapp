# Delivery App - Quick Start Guide

**For daily development workflow**

---

## Starting Your Development Session

### 1. Start Backend Services (Docker)
```bash
cd ~/Sites/deliveryapp
docker compose up -d
```

### 2. Verify Backend is Running
```bash
# Quick health check
curl http://localhost:8080/health

# Full API test
curl http://localhost:8080/api.php | jq
```

### 3. Start Flutter Development
```bash
cd ~/Sites/deliveryapp/mobile

# For web development (Chrome)
flutter run -d chrome

# For Linux desktop
flutter run -d linux

# List available devices
flutter devices
```

---

## Stopping Your Development Session

```bash
# Stop all Docker containers
cd ~/Sites/deliveryapp
docker compose down

# Or keep them running (they auto-restart)
```

---

## Common Development Tasks

### Backend Development

```bash
# View backend logs
docker compose logs -f backend

# Access backend shell
docker compose exec backend bash

# Run Composer commands
docker compose exec -u root backend composer require package/name
docker compose exec -u root backend composer update

# Run PHP scripts
docker compose exec backend php script.php

# Database access
docker compose exec database mysql -u delivery_user -p deliveryapp
```

### Frontend Development

```bash
cd mobile

# Hot reload (automatic on save)
# Just edit files in lib/ directory

# Run tests
flutter test

# Format code
flutter format lib/

# Analyze code
flutter analyze

# Update dependencies
flutter pub get
```

### Database Management

```bash
# Via phpMyAdmin
open http://localhost:8081
# User: delivery_user
# Pass: secure_password_change_me

# Via command line
docker compose exec database mysql -u delivery_user -p
```

---

## File Locations

### Backend
- **Entry Point:** `backend/public/index.php`
- **API Endpoint:** `backend/public/api.php`
- **Business Logic:** `backend/src/Domain/`
- **Controllers:** `backend/src/Presentation/Controllers/`
- **Config:** `backend/config/`

### Flutter
- **Main App:** `mobile/lib/main.dart`
- **Features:** `mobile/lib/features/`
- **Tests:** `mobile/test/`

---

## Access Points

| Service | URL | Notes |
|---------|-----|-------|
| Backend API | http://localhost:8080 | Main backend |
| API Endpoint | http://localhost:8080/api.php | REST API |
| phpMyAdmin | http://localhost:8081 | Database GUI |
| Flutter Web | http://localhost:* | Auto-assigned port |

---

## Troubleshooting

### "Port already in use"
```bash
# Find what's using the port
sudo lsof -i :8080

# Stop Docker and restart
docker compose down && docker compose up -d
```

### "Cannot connect to database"
```bash
# Restart database
docker compose restart database

# Check logs
docker compose logs database
```

### "Flutter command not found"
```bash
# Add Flutter to PATH
export PATH="$PATH:$HOME/development/flutter/bin"

# Or reload shell
source ~/.bashrc
```

### "Permission denied in backend"
```bash
# Fix file permissions
docker compose exec -u root backend chown -R www-data:www-data /var/www/html
```

---

## Code Quality Commands

### Backend (PHP)
```bash
# Run tests
docker compose exec backend vendor/bin/phpunit

# Static analysis
docker compose exec backend vendor/bin/phpstan analyse

# Code style check
docker compose exec backend vendor/bin/phpcs src

# Code style fix
docker compose exec backend vendor/bin/phpcbf src
```

### Frontend (Flutter)
```bash
cd mobile

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
flutter format .
```

---

## Git Workflow

```bash
# Check status
git status

# Create feature branch
git checkout -b feature/your-feature-name

# Stage changes
git add .

# Commit with meaningful message
git commit -m "feat: add user authentication"

# Push to remote
git push origin feature/your-feature-name
```

---

## Environment Variables

Create `.env` in backend directory:
```env
APP_ENV=development
APP_DEBUG=true
DB_HOST=database
DB_PORT=3306
DB_NAME=deliveryapp
DB_USER=delivery_user
DB_PASSWORD=secure_password_change_me
REDIS_HOST=cache
REDIS_PORT=6379
REDIS_PASSWORD=redis_password_change_me
```

---

## Need Help?

- **Backend Issues:** Check `docker compose logs backend`
- **Database Issues:** Check `docker compose logs database`
- **Flutter Issues:** Run `flutter doctor -v`
- **Full Setup Guide:** See [SETUP_COMPLETE.md](SETUP_COMPLETE.md)

---

**Quick Tip:** Keep two terminal windows open:
1. **Terminal 1:** Backend logs (`docker compose logs -f`)
2. **Terminal 2:** Flutter development (`cd mobile && flutter run`)

This gives you real-time feedback from both ends of your application!
