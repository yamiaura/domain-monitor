# Docker Setup for Domain Monitor

This directory contains Docker configuration files for running Domain Monitor in containers.

## Quick Start

1. **Copy environment file**
   ```bash
   cp .env.docker .env
   ```

2. **Edit `.env` and set secure passwords**
   ```bash
   # Change these values:
   DB_PASSWORD=your_secure_password
   DB_ROOT_PASSWORD=your_root_password
   ```

3. **Start containers**
   ```bash
   docker-compose up -d
   ```

4. **Access the application**
   - Application: http://localhost:8080
   - Follow the web installer to complete setup

5. **Optional: Start phpMyAdmin**
   ```bash
   docker-compose --profile tools up -d
   ```
   - phpMyAdmin: http://localhost:8081

## Container Management

### Start containers
```bash
docker-compose up -d
```

### Stop containers
```bash
docker-compose down
```

### View logs
```bash
# All containers
docker-compose logs -f

# Specific container
docker-compose logs -f app
docker-compose logs -f db
```

### Restart containers
```bash
docker-compose restart
```

### Rebuild containers (after code changes)
```bash
docker-compose up -d --build
```

## Accessing the Application

After starting containers, visit http://localhost:8080 and follow the web installer:

1. The installer will check database connectivity
2. Create database tables automatically
3. Generate encryption key
4. Set admin credentials

**Important:** Save your admin password - it's shown only once!

## Cron Jobs

Cron is automatically configured inside the container to run domain checks daily at 9:00 AM.

To manually trigger a check:
```bash
docker-compose exec app php /var/www/html/cron/check_domains.php
```

## Database Access

### Using phpMyAdmin
```bash
docker-compose --profile tools up -d
```
Visit http://localhost:8081

### Using MySQL CLI
```bash
docker-compose exec db mysql -u domain_monitor -p domain_monitor
```

### Backup Database
```bash
docker-compose exec db mysqldump -u root -p domain_monitor > backup.sql
```

### Restore Database
```bash
docker-compose exec -T db mysql -u root -p domain_monitor < backup.sql
```

## Persistent Data

The following directories are mounted as volumes to persist data:

- `./logs` - Application logs
- `./cache` - Application cache
- `./public/uploads` - User uploads (avatars)
- `./.env` - Environment configuration
- `db-data` (Docker volume) - MySQL database files

## Customization

### Change Ports

Edit `.env`:
```bash
APP_PORT=8080      # Application port
DB_PORT=3306       # Database port (external)
PMA_PORT=8081      # phpMyAdmin port
```

### Production Deployment

1. Use strong passwords in `.env`
2. Consider using a reverse proxy (nginx/Traefik) with SSL
3. Restrict database port access (remove port mapping)
4. Regular backups of database and uploads

### Development Mode

Edit `.env`:
```bash
APP_ENV=development
```

This enables detailed error messages and debugging.

## Troubleshooting

### Database connection failed
```bash
# Check if database is ready
docker-compose logs db

# Verify credentials in .env match docker-compose.yml
```

### Permission errors
```bash
# Fix permissions
docker-compose exec app chown -R www-data:www-data /var/www/html
docker-compose exec app chmod -R 775 /var/www/html/cache /var/www/html/logs
```

### Cron not running
```bash
# Check cron status
docker-compose exec app service cron status

# View cron logs
docker-compose exec app tail -f /var/www/html/logs/cron.log
```

### Reset everything
```bash
# Stop and remove containers, volumes
docker-compose down -v

# Remove .installed flag
rm .installed

# Start fresh
docker-compose up -d
```

## Security Notes

- Never commit `.env` to version control
- Use strong passwords for database
- Keep Docker images updated
- Restrict database port access in production
- Use HTTPS in production (reverse proxy)
