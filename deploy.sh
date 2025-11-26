set -e  

APP_DIR="/home/deployer/blue-green-app"

#Color recibido por parámetro (opcional)
COLOR="$1"

#Si no hay parámetro, alternar automáticamente con current_color
if [ -z "$COLOR" ]; then
  if [ -f "$APP_DIR/current_color" ]; then
    CURRENT=$(cat "$APP_DIR/current_color")
    if [ "$CURRENT" = "blue" ]; then
      COLOR="green"
    else
      COLOR="blue"
    fi
  else
    COLOR="blue"
  fi
fi

# 3) Validar color
if [ "$COLOR" != "blue" ] && [ "$COLOR" != "green" ]; then
  echo "Uso: $0 [blue|green]"
  exit 1
fi

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

echo "$COLOR" > current_color

echo ">>> Despliegue Blue-Green completado. Color activo: $COLOR"
