# Docker Fundamentals - Delivery App Tutorial

**Sprint 0 - Story 1: Learn Docker Fundamentals**

This guide will teach you Docker basics through hands-on practice with your delivery app setup.

---

## 📋 Table of Contents

1. [Install Docker](#1-install-docker)
2. [Docker Core Concepts](#2-docker-core-concepts)
3. [Hands-On Tutorial](#3-hands-on-tutorial)
4. [Build & Run Delivery App](#4-build--run-delivery-app)
5. [Docker Commands Cheat Sheet](#5-docker-commands-cheat-sheet)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. Install Docker

### Linux (Ubuntu/Debian)

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (avoid using sudo)
sudo usermod -aG docker $USER

# IMPORTANT: Log out and log back in for group changes to take effect
```

### Verify Installation

```bash
docker --version
docker compose version

# Test Docker
docker run hello-world
```

---

## 2. Docker Core Concepts

### 🖼️ Images vs Containers

| **Concept** | **Description** | **Analogy** |
|-------------|-----------------|-------------|
| **Image** | Blueprint/template (read-only) | Class in OOP |
| **Container** | Running instance of an image | Object instance |
| **Dockerfile** | Recipe to build an image | Constructor |

**Example:**
```bash
# Pull an image from Docker Hub
docker pull nginx:alpine

# List images
docker images

# Run a container from the image
docker run -d -p 8080:80 --name my-nginx nginx:alpine

# List running containers
docker ps

# Stop and remove
docker stop my-nginx
docker rm my-nginx
```

### 💾 Volumes (Persistent Data)

Containers are **ephemeral** (temporary). When you delete a container, all data inside is lost. **Volumes** persist data.

```bash
# Create a volume
docker volume create mysql-data

# Run MySQL with persistent storage
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=secret \
  -v mysql-data:/var/lib/mysql \
  mysql:8.0

# List volumes
docker volume ls

# Inspect volume
docker volume inspect mysql-data

# Remove volume (data will be deleted!)
docker volume rm mysql-data
```

### 🌐 Networks (Container Communication)

Containers on the same network can communicate using **container names as hostnames**.

```bash
# Create a network
docker network create delivery-network

# Run containers on the same network
docker run -d --name backend --network delivery-network php:8.4-apache
docker run -d --name database --network delivery-network mysql:8.0

# Inside 'backend' container, you can connect to MySQL using hostname 'database'
```

---

## 3. Hands-On Tutorial

### Step 1: Run Your First Container (Nginx)

```bash
# Pull and run nginx
docker run -d -p 8080:80 --name test-nginx nginx:alpine

# Check if it's running
docker ps

# View logs
docker logs test-nginx

# Execute commands inside the container
docker exec -it test-nginx sh

# Inside container:
ls /usr/share/nginx/html
cat /etc/nginx/nginx.conf
exit

# Stop and remove
docker stop test-nginx
docker rm test-nginx
```

**Test:** Open http://localhost:8080 in your browser. You should see "Welcome to nginx!"

### Step 2: Understand Dockerfile

A **Dockerfile** is a script that defines how to build a Docker image.

**Example:** See `docker/php/Dockerfile` in this project.

Key instructions:
- `FROM` - Base image (e.g., `php:8.4-apache`)
- `RUN` - Execute commands (install packages, etc.)
- `COPY` - Copy files from host to container
- `WORKDIR` - Set working directory
- `EXPOSE` - Document which ports the container listens on
- `CMD` - Default command to run when container starts

### Step 3: Understand Docker Compose

**Docker Compose** orchestrates multiple containers (services) together.

**Example:** See `docker-compose.yml` in this project.

Key concepts:
- `services` - Define containers (backend, database, cache)
- `volumes` - Persistent storage
- `networks` - Communication between containers
- `depends_on` - Start order (backend waits for database)

---

## 4. Build & Run Delivery App

### Build and Start All Services

```bash
# Build images and start containers
docker compose up -d

# View logs
docker compose logs -f

# Check running containers
docker compose ps
```

### Access Services

| **Service** | **URL** | **Purpose** |
|-------------|---------|-------------|
| Backend | http://localhost:8080 | PHP application |
| phpMyAdmin | http://localhost:8081 | Database management |
| MySQL | localhost:3306 | Database (connect via phpMyAdmin or CLI) |
| Redis | localhost:6379 | Cache (CLI only) |

### Test Backend

Open http://localhost:8080 in your browser. You should see:
- PHP version
- Database connection status
- Redis connection status
- Loaded extensions

### Stop Services

```bash
# Stop all containers
docker compose down

# Stop and remove volumes (WARNING: deletes database data!)
docker compose down -v
```

---

## 5. Docker Commands Cheat Sheet

### Container Management

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop <container_name>

# Start a stopped container
docker start <container_name>

# Restart a container
docker restart <container_name>

# Remove a container
docker rm <container_name>

# Remove all stopped containers
docker container prune
```

### Image Management

```bash
# List images
docker images

# Remove an image
docker rmi <image_name>

# Remove unused images
docker image prune
```

### Logs & Debugging

```bash
# View logs
docker logs <container_name>

# Follow logs (live stream)
docker logs -f <container_name>

# Execute command inside running container
docker exec -it <container_name> bash

# Inspect container
docker inspect <container_name>
```

### Docker Compose

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Rebuild images
docker compose build

# Rebuild and restart
docker compose up -d --build

# View logs
docker compose logs -f <service_name>

# Execute command in service
docker compose exec backend bash
```

---

## 6. Troubleshooting

### Common Issues

#### ❌ "Cannot connect to Docker daemon"

**Solution:** Start Docker service
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

#### ❌ "Permission denied while trying to connect to the Docker daemon socket"

**Solution:** Add user to docker group
```bash
sudo usermod -aG docker $USER
# Log out and log back in
```

#### ❌ Port already in use (e.g., 8080, 3306)

**Solution:** Change port in `docker-compose.yml`
```yaml
ports:
  - "8888:80"  # Change 8080 to 8888
```

#### ❌ Database connection failed

**Solution:** Wait for MySQL to initialize (first run takes ~30 seconds)
```bash
docker compose logs database
# Wait for: "ready for connections"
```

#### ❌ Container keeps restarting

**Solution:** Check logs
```bash
docker compose logs <service_name>
```

---

## 🎯 Definition of Done

You have completed **Story 1: Learn Docker Fundamentals** when you can:

- [ ] Explain the difference between images and containers
- [ ] Run an nginx container and access it in your browser
- [ ] Understand volumes and networks
- [ ] Build a custom Docker image using a Dockerfile
- [ ] Run multi-container setup with `docker-compose up -d`
- [ ] Access the delivery app backend at http://localhost:8080
- [ ] View database using phpMyAdmin at http://localhost:8081
- [ ] Read and modify `docker-compose.yml`
- [ ] Use basic Docker commands (ps, logs, exec, stop, rm)

---

## 📚 Next Steps

After mastering Docker fundamentals:

1. **Sprint 0 - Story 2:** Setup Local Development Environment (PHP 8.4, Composer, Flutter)
2. **Sprint 0 - Story 3:** Project Architecture Design (Clean Architecture, ERD)

---

## 🔗 Useful Resources

- [Official Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/) - Find images
- [Play with Docker](https://labs.play-with-docker.com/) - Free online Docker playground

---

**Happy Learning! 🚀**
