# Docker Arsitektur Frontend Backend Storage DB

Docker environment arsitektur yang terdiri dari 3 node replica untuk aplikasi frontend web, 1 node backend, 1 node storage file di dalam WSL, dan 1 node database MySQL.


## Struktur Proyek

```
.
├── docker-compose.yml
├── .env
└── docker
    ├── frontend
    │   ├── Dockerfile
    │   └── nginx.conf
    ├── backend
    │   ├── Dockerfile
    │   └── nginx.conf
    ├── storage
    │   ├── Dockerfile
    │   └── nginx.conf
    └── mysql
        └── Dockerfile
```

## Spesifikasi Server

### Frontend Web App (3 Node Replica)
- OS: Ubuntu 22.04 minimal tanpa GUI
- Services: nginx, git, composer, php8.1 & php-fpm
- IP Addresses:
  - Node 1: 192.168.7.10
  - Node 2: 192.168.7.11
  - Node 3: 192.168.7.12

### Backend App Node
- OS: Ubuntu 22.04 minimal tanpa GUI
- Services: nginx, git, composer, php8.1 & php-fpm
- IP Address: 192.168.7.13

### Storage File Node (WSL)
- OS: Ubuntu 22.04 minimal tanpa GUI
- Services: nginx, git, composer
- IP Address: 192.168.7.14
- Mount Points:
  - Source: `/docker_storage_file/app1/`
  - Target: `/var/www/public/uploads/`

### Database MySQL Node
- OS: Ubuntu 22.04 minimal tanpa GUI
- Services: nginx, git, composer, php8.1 & php-fpm, MySQL
- IP Address: 192.168.7.15
- Credentials:
  - Database: bukutamu
  - Username: arvino
  - Password: 123456789

## Instalasi dan Konfigurasi

### 1. Persiapan WSL Storage
```bash
# Buat direktori storage
sudo mkdir -p /docker_storage_file/app1
sudo chown -R $USER:$USER /docker_storage_file/app1
sudo chmod -R 755 /docker_storage_file/app1

# Konfigurasi WSL
sudo nano /etc/wsl.conf
# Tambahkan konfigurasi berikut:
# [automount]
# enabled = true
# options = "metadata,umask=22,fmask=11"
# mountFsTab = false

# Restart WSL
wsl --shutdown
```

### 2. Menjalankan Docker Environment
```bash
# Build dan jalankan container
docker-compose up -d

# Verifikasi status container
docker-compose ps

# Test koneksi MySQL
docker-compose exec mysql mysql -u arvino -p123456789 bukutamu
```

## Verifikasi Sistem

### 1. Cek Frontend Nodes
```bash
# Test akses ke masing-masing frontend node
curl http://192.168.7.10
curl http://192.168.7.11
curl http://192.168.7.12
```

### 2. Cek Storage WSL
```bash
# Verifikasi direktori mounting
ls -la /docker_storage_file/app1
ls -la /var/www/public/uploads  # di dalam container storage
```

### 3. Cek Database
```bash
# Masuk ke MySQL console
docker-compose exec mysql mysql -u arvino -p123456789 bukutamu

# Di dalam MySQL console
SHOW DATABASES;
USE bukutamu;
SHOW TABLES;
```

## Maintenance

### Restart Service
```bash
# Restart semua container
docker-compose restart

# Restart container spesifik
docker-compose restart frontend1
docker-compose restart mysql
```

### Logs
```bash
# Lihat logs semua container
docker-compose logs

# Lihat logs container spesifik
docker-compose logs frontend1
docker-compose logs mysql
```


## Developer
- **Nama**: Arvino Zulka
- **Website**: [https://www.arvino.my.id/](https://www.arvino.my.id/)

## Docker Swarm Setup

### 1. Inisialisasi Swarm
```bash
# Di Master Node (192.168.7.10)
docker swarm init --advertise-addr 192.168.7.10

# Simpan token join yang dihasilkan untuk worker nodes
```

### 2. Join Worker Nodes
```bash
# Di setiap worker node, jalankan perintah join yang didapat dari master
docker swarm join --token <worker-token> 192.168.7.10:2377
```

### 3. Deploy Stack
```bash
# Di Master Node
docker stack deploy -c docker-stack.yml app_stack

# Verifikasi deployment
docker stack ps app_stack
docker service ls
```

### 4. Scaling dan Failover
```bash
# Scale service
docker service scale app_stack_frontend=5

# Cek status node
docker node ls

# Cek service logs
docker service logs app_stack_frontend
```

### 5. Update Service
```bash
# Update image
docker service update --image newimage:tag app_stack_frontend

# Rolling update dengan zero downtime
docker service update --update-parallelism 1 --update-delay 10s app_stack_frontend
```

## Monitoring Swarm

### 1. Service Health
```bash
# Cek status services
docker service ls
docker service ps app_stack_frontend

# Inspect service
docker service inspect app_stack_frontend
```

### 2. Node Management
```bash
# List semua node
docker node ls

# Drain node untuk maintenance
docker node update --availability drain <node-id>

# Activate node setelah maintenance
docker node update --availability active <node-id>
```
