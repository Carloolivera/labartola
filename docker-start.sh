#!/bin/bash

# Script de inicio de Docker para La Bartola
# Este script inicia todos los servicios de Docker

echo "🚀 Iniciando La Bartola con Docker..."
echo ""

# Verificar si Docker está corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo."
    echo "Por favor, inicia Docker Desktop y vuelve a intentar."
    exit 1
fi

# Detener contenedores antiguos si existen
echo "🛑 Deteniendo contenedores anteriores (si existen)..."
docker-compose down

# Construir y levantar los contenedores
echo ""
echo "🏗️  Construyendo y levantando contenedores..."
docker-compose up -d --build

# Verificar el estado
echo ""
echo "✅ Verificando estado de los contenedores..."
docker-compose ps

echo ""
echo "🎉 ¡La Bartola está corriendo!"
echo ""
echo "📍 URLs disponibles:"
echo "   - Aplicación Web: http://localhost:8080"
echo "   - phpMyAdmin:     http://localhost:8088"
echo ""
echo "📊 Para ver los logs en tiempo real:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 Para detener los servicios:"
echo "   docker-compose down"
echo ""
