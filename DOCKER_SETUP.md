# Configuración de Docker para La Bartola

Este proyecto está completamente dockerizado con PHP 8.2, Apache, MySQL 8.0 y phpMyAdmin. **Ya no necesitas usar `php spark serve`** - Docker maneja todo.

## 🚀 Inicio Rápido

### Opción 1: Usando los scripts (Recomendado)

```bash
# Linux/Mac
./docker-start.sh

# Windows (Git Bash)
bash docker-start.sh
```

### Opción 2: Comandos manuales

```bash
docker-compose up -d --build
```

## ⚙️ Requisitos Previos

- Docker Desktop instalado y corriendo
- Git Bash o terminal compatible (para Windows)

## 📁 Estructura de Docker

```
labartola/
├── docker-compose.yml          # Configuración de servicios
├── Dockerfile                  # Imagen de PHP + Apache
├── .env                        # Variables de entorno (NO subir a git)
├── .env.example                # Plantilla de variables de entorno
├── docker-start.sh             # Script de inicio rápido
├── docker-stop.sh              # Script para detener servicios
├── docker-logs.sh              # Script para ver logs
├── docker/
│   ├── apache/
│   │   └── 000-default.conf   # Configuración de Apache
│   └── mysql/
│       └── init.sql            # Script de inicialización de BD
└── .dockerignore              # Archivos excluidos del build
```

## 🐳 Servicios Configurados

### 1. MySQL (labartola_mysql)
- **Puerto**: `3306` (host) → `3306` (contenedor)
- **Usuario**: `labartola_user`
- **Password**: `root_password_2024`
- **Base de datos**: `labartola`
- **Volumen persistente**: `db_data`

### 2. Web (labartola_web) - **PHP + Apache**
- **Puerto**: `8080` (host) → `80` (contenedor)
- **PHP**: 8.2 con Apache
- **Extensiones**: mysqli, pdo, pdo_mysql, zip, gd, intl
- **mod_rewrite**: Habilitado para URLs limpias
- **DocumentRoot**: `/var/www/html/public`

### 3. phpMyAdmin (labartola_phpmyadmin)
- **Puerto**: `8088`
- **Acceso**: http://localhost:8088
- **Usuario**: `labartola_user`
- **Password**: `root_password_2024`

## 🎯 Acceso a la Aplicación

Una vez levantados los contenedores:

- **🌐 Aplicación Web**: http://localhost:8080
- **🗄️ phpMyAdmin**: http://localhost:8088
- **💾 MySQL** (desde host): `localhost:3306`

## 📝 Scripts Disponibles

### Iniciar servicios
```bash
./docker-start.sh
```
Construye y levanta todos los contenedores. Muestra las URLs disponibles.

### Detener servicios
```bash
./docker-stop.sh
```
Detiene todos los contenedores sin borrar datos.

### Ver logs en tiempo real
```bash
./docker-logs.sh
```
Muestra los logs de todos los servicios. Presiona `Ctrl+C` para salir.

## 🛠️ Comandos Útiles de Docker

### Ver estado de contenedores
```bash
docker-compose ps
```

### Reiniciar servicios
```bash
# Reiniciar todo
docker-compose restart

# Reiniciar solo web
docker-compose restart web

# Reiniciar solo MySQL
docker-compose restart mysql
```

### Acceder al contenedor web
```bash
docker exec -it labartola_web bash
```

### Ejecutar comandos de CodeIgniter
```bash
# Desde fuera del contenedor
docker exec -it labartola_web php spark list
docker exec -it labartola_web php spark migrate
docker exec -it labartola_web php spark db:seed UserSeeder

# Desde dentro del contenedor
docker exec -it labartola_web bash
php spark list
php spark migrate
```

### Ver logs de servicios específicos
```bash
# Web (Apache + PHP)
docker-compose logs -f web

# MySQL
docker-compose logs -f mysql

# phpMyAdmin
docker-compose logs -f phpmyadmin
```

### Detener y eliminar todo (incluyendo volúmenes)
```bash
# CUIDADO: Esto borra la base de datos
docker-compose down -v
```

## ⚙️ Configuración con .env

El archivo `.env` contiene todas las configuraciones importantes:

```env
# Configuración de la aplicación
CI_ENVIRONMENT = development
app.baseURL = 'http://localhost:8080/'
app.indexPage = ''

# Configuración de la base de datos
database.default.hostname = mysql
database.default.database = labartola
database.default.username = labartola_user
database.default.password = root_password_2024

# Puertos de Docker
WEB_PORT = 8080
DB_PORT = 3306
PHPMYADMIN_PORT = 8088
```

**Nota**: El archivo `.env` está en `.gitignore` para proteger credenciales. Usa `.env.example` como plantilla.

## 🔧 Cambiar Puertos

Si algún puerto está ocupado, edita el archivo `.env`:

```env
# Cambiar puerto web de 8080 a 8081
WEB_PORT = 8081

# Cambiar puerto MySQL de 3306 a 3307
DB_PORT = 3307

# Cambiar puerto phpMyAdmin de 8088 a 8089
PHPMYADMIN_PORT = 8089
```

Luego reinicia los servicios:
```bash
docker-compose down
docker-compose up -d
```

## 🐛 Solución de Problemas

### El puerto está ocupado
```bash
# Ver qué proceso usa el puerto 8080 (Linux/Mac)
lsof -i :8080

# Ver qué proceso usa el puerto 8080 (Windows PowerShell)
Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess

# Matar proceso en Windows
Stop-Process -Id <PID> -Force

# O cambiar el puerto en .env
WEB_PORT = 8081
```

### Docker no está corriendo
```bash
# Verificar si Docker está corriendo
docker info

# Si no está corriendo, inicia Docker Desktop
```

### La base de datos no se inicializa
```bash
# Eliminar volúmenes y recrear todo
docker-compose down -v
docker-compose up -d --build
```

### Errores de permisos en writable/
```bash
docker exec -it labartola_web bash
chown -R www-data:www-data /var/www/html/writable
chmod -R 775 /var/www/html/writable
exit
```

### Ver errores de Apache
```bash
docker exec -it labartola_web tail -f /var/log/apache2/error.log
```

### Ver errores de PHP
```bash
docker exec -it labartola_web tail -f /var/www/html/writable/logs/log-*.log
```

### La aplicación muestra 404
1. Verifica que mod_rewrite esté habilitado (ya está en el Dockerfile)
2. Verifica que `app.indexPage` esté vacío en `.env`
3. Reinicia el contenedor web: `docker-compose restart web`

## 💾 Backup y Restauración

### Exportar base de datos
```bash
docker exec labartola_mysql mysqldump \
  -ulabartola_user \
  -proot_password_2024 \
  labartola > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Importar base de datos
```bash
docker exec -i labartola_mysql mysql \
  -ulabartola_user \
  -proot_password_2024 \
  labartola < backup.sql
```

## 🚀 Desarrollo

### Ventajas de usar Docker:
✅ **Hot reload**: Los cambios en el código se reflejan inmediatamente
✅ **No necesitas XAMPP/WAMP**: Todo está contenido en Docker
✅ **Mismo ambiente para todos**: Evita el "en mi máquina funciona"
✅ **Fácil de iniciar**: Un solo comando levanta todo
✅ **URLs limpias**: mod_rewrite configurado automáticamente

### Flujo de trabajo:
1. Inicia Docker: `./docker-start.sh`
2. Edita tu código en tu editor favorito
3. Recarga el navegador para ver cambios
4. Cuando termines: `./docker-stop.sh`

### Ejecutar migraciones y seeders:
```bash
# Ejecutar todas las migraciones
docker exec -it labartola_web php spark migrate

# Ejecutar un seeder específico
docker exec -it labartola_web php spark db:seed UserSeeder

# Rollback de migraciones
docker exec -it labartola_web php spark migrate:rollback
```

## 📊 Base de Datos

El archivo `docker/mysql/init.sql` se ejecuta automáticamente al crear el contenedor MySQL por primera vez. Crea las siguientes tablas:

- users
- platos
- pedidos
- pedido_items
- cupones
- cupones_usos
- notificaciones
- caja_turnos
- caja_movimientos
- inventario_productos
- inventario_movimientos
- migrations

## 🔒 Seguridad

- ⚠️ **Nunca subas el archivo `.env` a git** (ya está en `.gitignore`)
- 🔑 Cambia las contraseñas en producción
- 🔐 Usa contraseñas fuertes para producción
- 🌐 No expongas los puertos de base de datos en producción

## 📌 Notas Importantes

1. **Primera vez**: El contenedor MySQL tarda ~10 segundos en inicializarse
2. **Healthcheck**: El servicio web espera a que MySQL esté listo antes de iniciar
3. **Persistencia**: Los datos de MySQL se guardan en el volumen `db_data`
4. **Red**: Todos los contenedores están en la red `labartola_network`
5. **No más spark serve**: Apache maneja todo el enrutamiento
6. **Cambios inmediatos**: No necesitas rebuildar para ver cambios de código
