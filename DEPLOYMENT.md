# Deployment Guide - Pedometer API

## Variables de Entorno Requeridas

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `DATABASE_URL` | URL de conexión PostgreSQL | `${{Postgres.DATABASE_URL}}` (Railway) |
| `RAILS_ENV` | Entorno de Rails | `production` |
| `RAILS_MASTER_KEY` | Clave maestra para credentials | Contenido de `config/master.key` |
| `PORT` | Puerto del servidor (opcional) | `3000` (default) |

## Configuración en Railway

### 1. Variables del servicio web

En **Settings > Variables** del servicio Rails:

```
DATABASE_URL = ${{Postgres.DATABASE_URL}}
RAILS_ENV = production
RAILS_MASTER_KEY = <contenido de config/master.key>
```

### 2. Archivos de configuración

El proyecto usa estos archivos para Railway:

- `nixpacks.toml` - Define el comando de inicio
- `railway.toml` - Configura el builder (nixpacks)
- `Procfile` - Fallback para otros PaaS

### 3. Comando de inicio

```bash
bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}
```

## Verificación Pre-Deploy

Ejecuta esto localmente antes de hacer push:

```bash
bin/check-deploy
```

## Troubleshooting

### Error: `ActiveRecord::AdapterNotSpecified`

**Causa**: `database.yml` mal configurado o `DATABASE_URL` no disponible.

**Solución**:
1. Verificar que `DATABASE_URL` existe en las variables del servicio web
2. Verificar que `database.yml` tiene `adapter: postgresql` en `default`
3. Verificar que `production` hereda de `default` con `<<: *default`

### Error: `PG::ConnectionBad`

**Causa**: No puede conectar a PostgreSQL.

**Solución**:
1. Verificar que el servicio Postgres está corriendo
2. Verificar que `DATABASE_URL` apunta al servicio correcto
3. En Railway: usar `${{Postgres.DATABASE_URL}}` (sintaxis de referencia)

### Error: `Credentials not found`

**Causa**: Falta `RAILS_MASTER_KEY`.

**Solución**:
1. Copiar contenido de `config/master.key` local
2. Añadir como variable `RAILS_MASTER_KEY` en Railway

## Estructura de Base de Datos

Este proyecto usa una **única base de datos** PostgreSQL.

Los gems `solid_cache`, `solid_queue` y `solid_cable` están **desactivados** en producción para simplificar el deployment. Usan adaptadores en memoria:

- Cache: `:memory_store`
- Queue: `:async`
- Cable: `:async`

Si necesitas persistencia para jobs o cache, consulta la documentación de Rails 8 para configurar múltiples bases de datos.

## Archivos Críticos - NO MODIFICAR

```
config/database.yml          # Configuración DB - estructura validada
config/environments/production.rb  # Cache y Queue en memoria
nixpacks.toml                # Comando de inicio para Railway
```

Cualquier cambio en estos archivos requiere verificar el deploy con `bin/check-deploy`.
