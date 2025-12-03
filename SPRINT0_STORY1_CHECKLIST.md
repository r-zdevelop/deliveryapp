# Sprint 0 - Story 1: Learn Docker Fundamentals

**Story Points:** 5
**Status:** In Progress

---

## Definition of Done Checklist

### 📚 Docker Concepts Understanding

- [ ] Can explain the difference between Docker **images** and **containers**
- [ ] Understands what **volumes** are and why they're needed
- [ ] Knows how Docker **networks** enable container communication
- [ ] Can describe what a **Dockerfile** does
- [ ] Understands the purpose of **Docker Compose**

### 🛠️ Practical Skills

- [ ] Docker and Docker Compose installed successfully
- [ ] Can run `docker --version` and `docker compose version`
- [ ] Successfully ran an nginx container tutorial
- [ ] Accessed nginx at http://localhost:8080 in browser
- [ ] Used `docker exec` to access a running container
- [ ] Viewed container logs with `docker logs`

### 🏗️ Project Setup

- [ ] Built custom PHP 8.4 Dockerfile
- [ ] Created docker-compose.yml with backend, database, and cache services
- [ ] Started all services with `docker compose up -d`
- [ ] All containers running (check with `docker compose ps`)
- [ ] Backend accessible at http://localhost:8080
- [ ] phpMyAdmin accessible at http://localhost:8081
- [ ] Backend shows successful MySQL connection
- [ ] Backend shows successful Redis connection

### 📋 Docker Commands Mastery

Can execute and understand these commands:

- [ ] `docker ps` - List running containers
- [ ] `docker images` - List images
- [ ] `docker logs <container>` - View logs
- [ ] `docker exec -it <container> bash` - Access container shell
- [ ] `docker compose up -d` - Start services
- [ ] `docker compose down` - Stop services
- [ ] `docker compose logs -f` - Stream logs
- [ ] `docker compose ps` - Check service status

### 📖 Documentation Review

- [ ] Read and understood [DOCKER_TUTORIAL.md](DOCKER_TUTORIAL.md)
- [ ] Reviewed [docker-compose.yml](docker-compose.yml) and understood each service
- [ ] Examined [Dockerfile](docker/php/Dockerfile) and understood each instruction
- [ ] Read [README.md](README.md) project overview

---

## Testing Verification

Run these commands to verify everything works:

```bash
# 1. Check Docker installation
docker --version
docker compose version

# 2. Start services
docker compose up -d

# 3. Verify all containers running
docker compose ps
# Expected: 4 containers (backend, database, cache, phpmyadmin)

# 4. Check backend health
curl http://localhost:8080

# 5. Check database connection from backend
docker compose exec backend php -r "
  \$pdo = new PDO('mysql:host=database;dbname=deliveryapp', 'delivery_user', 'secure_password_change_me');
  echo 'MySQL OK\n';
"

# 6. Check Redis connection
docker compose exec backend php -r "
  \$redis = new Redis();
  \$redis->connect('cache', 6379);
  \$redis->auth('redis_password_change_me');
  echo 'Redis OK\n';
"

# 7. View logs
docker compose logs backend
```

---

## Acceptance Criteria

✅ **Completed when:**

1. You can explain Docker core concepts to someone else
2. You successfully ran the nginx tutorial independently
3. All 4 services (backend, database, cache, phpmyadmin) are running
4. Backend displays "✅ Database connection successful"
5. Backend displays "✅ Redis connection successful"
6. You can use basic Docker commands without referencing documentation
7. You can read and modify `docker-compose.yml` configuration

---

## Next Steps After Completion

Once all checkboxes are ✅, proceed to:

**Sprint 0 - Story 2:** Setup Local Development Environment (PHP 8.4, Composer, Flutter)

---

## Troubleshooting

If you encounter issues, refer to:
- [DOCKER_TUTORIAL.md - Troubleshooting Section](DOCKER_TUTORIAL.md#6-troubleshooting)
- Run `docker compose logs <service_name>` to debug
- Check container status: `docker compose ps`

---

**Good luck! 🚀**
