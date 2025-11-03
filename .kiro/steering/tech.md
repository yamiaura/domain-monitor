# Technology Stack

## Core Technologies

- **PHP**: 8.1+ (strict typing, modern features)
- **Database**: MySQL 5.7+ or MariaDB 10.3+
- **Web Server**: Apache/Nginx with mod_rewrite
- **Dependency Management**: Composer

## Key Dependencies

```json
{
  "vlucas/phpdotenv": "^5.5",           // Environment configuration
  "phpmailer/phpmailer": "^6.8",        // Email notifications
  "guzzlehttp/guzzle": "^7.8",          // HTTP client for webhooks
  "pragmarx/google2fa": "^8.0",         // Two-factor authentication
  "endroid/qr-code": "^4.8"             // QR code generation for 2FA
}
```

## Architecture Pattern

Custom lightweight MVC framework (no Laravel/Symfony):

- **Router**: Simple pattern-based routing with dynamic segments
- **Controllers**: Handle HTTP requests, coordinate between models and views
- **Models**: Database interaction using PDO with prepared statements
- **Views**: Pure PHP templates (no Blade/Twig)
- **Services**: Business logic layer (WhoisService, NotificationService, etc.)
- **Helpers**: Formatting and display utilities

## Common Commands

### Docker Setup (Recommended)
```bash
# Start containers
docker-compose up -d

# View logs
docker-compose logs -f

# Stop containers
docker-compose down

# Rebuild after changes
docker-compose up -d --build

# Run cron manually
docker-compose exec app php /var/www/html/cron/check_domains.php

# Access database
docker-compose exec db mysql -u domain_monitor -p

# Start phpMyAdmin (optional)
docker-compose --profile tools up -d
```

### Manual Development Setup
```bash
# Install dependencies
composer install

# Copy environment file
cp env.example.txt .env

# Run built-in server (development only)
php -S localhost:8000 -t public
```

### Database
```bash
# Web installer handles migrations automatically
# Visit: http://localhost:8000/install

# Manual TLD import (optional)
php cron/import_tld_registry.php
```

### Cron Jobs
```bash
# Domain expiration checks (configure in crontab)
php cron/check_domains.php

# Example crontab entry (daily at 9 AM)
0 9 * * * /usr/bin/php /path/to/cron/check_domains.php
```

### Production Deployment
```bash
# Optimize autoloader
composer install --no-dev --optimize-autoloader

# Set proper permissions
chmod -R 755 public/
chmod -R 775 cache/ logs/

# Ensure .env is not web-accessible
# Point web server to public/ directory only
```

## Environment Configuration

Key `.env` variables:
- `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`: Database connection
- `APP_ENCRYPTION_KEY`: Auto-generated during installation (32-byte hex)
- `APP_ENV`: `development` or `production` (affects error reporting)

Application settings (name, URL, timezone, email, monitoring) are managed through the web interface at `/settings`, not in `.env`.

## Docker Support

The project includes full Docker support with:
- **Dockerfile**: PHP 8.1-Apache with all required extensions
- **docker-compose.yml**: Multi-container setup (app, MySQL, phpMyAdmin)
- **Automatic cron**: Domain checks run daily at 9 AM inside container
- **Persistent volumes**: Logs, cache, uploads, and database data
- **Health checks**: Database readiness verification

Docker containers:
- `app`: PHP 8.1 + Apache + application code
- `db`: MySQL 8.0 database
- `phpmyadmin`: Optional database management (use `--profile tools`)

## Testing

No automated test suite currently. Manual testing workflow:
1. Test in development environment first (Docker or local)
2. Verify database migrations via `/install/update`
3. Test notification channels via Settings page
4. Validate cron jobs manually before scheduling
