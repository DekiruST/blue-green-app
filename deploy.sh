#!/bin/bash
set -e  # si algo falla, se detiene el script

COLOR=$1  # primer parámetro: blue o green

if [ "$COLOR" != "blue" ] && [ "$COLOR" != "green" ]; then
  echo "Uso: $0 blue|green"
  exit 1
fi

# Carpeta donde estará el proyecto en el VPS
APP_DIR="/home/deployer/blue-green-app"

echo ">>> Cambiando a entorno: $COLOR"

cd "$APP_DIR"

echo ">>> Construyendo imagen y levantando contenedor $COLOR..."
docker compose build app_$COLOR
docker compose up -d app_$COLOR

echo ">>> Actualizando configuración de Nginx..."
sudo cp nginx/${COLOR}.conf /etc/nginx/conf.d/app.conf

echo ">>> Probando configuración de Nginx..."
sudo nginx -t

echo ">>> Recargando Nginx..."
sudo systemctl reload nginx

# Guardamos qué color está activo
echo "$COLOR" > current_color

echo ">>> Despliegue Blue-Green completado. Color activo: $COLOR"
