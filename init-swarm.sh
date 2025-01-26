#!/bin/bash

# Inisialisasi swarm
docker swarm init --advertise-addr 192.168.7.10

# Build images
docker-compose -f docker-stack.yml build

# Deploy stack
docker stack deploy -c docker-stack.yml app_stack

# Verifikasi deployment
echo "Waiting for services to start..."
sleep 10
docker stack ps app_stack 