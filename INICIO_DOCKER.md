# 🚀 Inicio Rápido con Docker

¡Bienvenido! Ya no necesitas usar `php spark serve`. Docker maneja todo ahora.

## ⚡ Inicio en 2 pasos

### 1. Asegúrate que Docker Desktop esté corriendo

### 2. Ejecuta el script de inicio

**Linux/Mac:**
```bash
./docker-start.sh
```

**Windows (Git Bash):**
```bash
bash docker-start.sh
```

## 🎯 Accede a tu aplicación

- **Web**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8088

## ⏸️ Detener la aplicación

```bash
./docker-stop.sh
```

## 📊 Ver logs

```bash
./docker-logs.sh
```

## ❓ ¿Necesitas más ayuda?

Lee la documentación completa: [DOCKER_SETUP.md](DOCKER_SETUP.md)

---

## 🎓 Comandos útiles

```bash
# Ver estado
docker-compose ps

# Reiniciar todo
docker-compose restart

# Ejecutar migraciones
docker exec -it labartola_web php spark migrate

# Ver logs de errores
docker exec -it labartola_web tail -f /var/log/apache2/error.log
```

## 🔧 Solución rápida de problemas

**Puerto ocupado?** Edita `.env` y cambia `WEB_PORT=8080` a otro puerto.

**No inicia?** Ejecuta:
```bash
docker-compose down -v
docker-compose up -d --build
```

**Errores de permisos?** Ejecuta:
```bash
docker exec -it labartola_web chown -R www-data:www-data /var/www/html/writable
```
