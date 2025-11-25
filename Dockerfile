# Usa Nginx como base
FROM nginx:alpine

# Elimina contenido por defecto si quieres
RUN rm -rf /usr/share/nginx/html/*

# Copiamos nuestra app estática
COPY app/ /usr/share/nginx/html/

# Exponemos el puerto interno 80 (dentro del contenedor)
EXPOSE 80
