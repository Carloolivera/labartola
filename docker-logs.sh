#!/bin/bash

# Script para ver los logs de Docker

echo "📊 Mostrando logs de todos los servicios..."
echo "   Presiona Ctrl+C para salir"
echo ""

docker-compose logs -f
