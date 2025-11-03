# Project Structure

## Directory Organization

```
domain-monitor/
├── app/                          # Application layer
│   ├── Controllers/              # HTTP request handlers
│   ├── Models/                   # Database models (extend Core\Model)
│   ├── Services/                 # Business logic layer
│   │   ├── Channels/             # Notification channel implementations
│   │   ├── NotificationService.php
│   │   ├── WhoisService.php
│   │   └── ...
│   ├── Helpers/                  # Formatting and display utilities
│   │   ├── LayoutHelper.php     # Global layout data (notifications, stats)
│   │   ├── DomainHelper.php     # Domain formatting & calculations
│   │   └── SessionHelper.php    # Session display formatting
│   └── Views/                    # PHP templates (pure display, no business logic)
├── core/                         # Core MVC framework
│   ├── Application.php           # Application bootstrap
│   ├── Router.php                # Route resolution with dynamic segments
│   ├── Controller.php            # Base controller
│   ├── Model.php                 # Base model with PDO
│   ├── Database.php              # Database connection
│   ├── Auth.php                  # Authentication helpers
│   ├── Csrf.php                  # CSRF protection
│   ├── Encryption.php            # Encryption utilities
│   ├── DatabaseSessionHandler.php # Database-backed sessions
│   ├── SessionValidator.php      # Session validation middleware
│   └── SessionConfig.php         # Session configuration
├── cron/                         # Scheduled tasks
│   ├── check_domains.php         # Domain expiration checks
│   └── import_tld_registry.php   # TLD data import
├── database/
│   └── migrations/               # SQL migration files (numbered)
├── public/                       # Web root (ONLY this should be web-accessible)
│   ├── index.php                 # Application entry point
│   ├── .htaccess                 # Apache rewrite rules
│   ├── assets/                   # CSS, JS, images
│   └── robots.txt
├── routes/
│   └── web.php                   # Route definitions
├── cache/                        # Application cache (writable)
├── logs/                         # Application logs (writable)
├── vendor/                       # Composer dependencies
├── .env                          # Environment configuration (NOT in git)
├── composer.json                 # PHP dependencies
└── README.md                     # Documentation
```

## Key Architectural Patterns

### Controllers
- Extend `Core\Controller`
- Inject dependencies via constructor
- Use `$this->view()` to render templates
- Handle request validation and authorization
- Coordinate between models and services
- Example: `DomainController`, `AuthController`

### Models
- Extend `Core\Model`
- Define `protected static string $table`
- Use PDO with prepared statements (SQL injection protection)
- Provide CRUD operations: `all()`, `find()`, `create()`, `update()`, `delete()`
- Add custom query methods as needed
- Support user isolation mode where applicable
- Example: `Domain`, `User`, `NotificationGroup`

### Services
- Business logic layer (not tied to HTTP)
- Reusable across controllers and cron jobs
- Handle external integrations (WHOIS, notifications)
- Example: `WhoisService`, `NotificationService`, `TwoFactorService`

### Helpers
- Pure formatting and display utilities
- No database queries or business logic
- Used by views for consistent formatting
- Example: `DomainHelper::formatMultiple()`, `SessionHelper::formatLocation()`

### Views
- Pure PHP templates (no framework-specific syntax)
- Receive data from controllers via `$this->view($template, $data)`
- Use helpers for formatting
- No business logic or database queries
- Located in `app/Views/`

### Routing
- Defined in `routes/web.php`
- Supports static routes: `/domains`
- Supports dynamic segments: `/domains/{id}`
- HTTP methods: `$router->get()`, `$router->post()`
- Route format: `[ControllerClass::class, 'methodName']`

### Authentication
- `Auth::require()` - Protect routes (place before route definitions)
- `Auth::check()` - Check if user is logged in
- `Auth::id()` - Get current user ID
- `Auth::user()` - Get current user data
- `Auth::isAdmin()` - Check admin status
- Database-backed sessions with `DatabaseSessionHandler`

### Database Migrations
- Sequential numbered SQL files: `001_initial.sql`, `002_add_feature.sql`
- Located in `database/migrations/`
- Applied via web installer at `/install/update`
- Use `IF NOT EXISTS` for idempotency
- Registered in `InstallerController::$incrementalMigrations`

## Naming Conventions

- **Classes**: PascalCase (`DomainController`, `WhoisService`)
- **Methods**: camelCase (`getDomainInfo`, `sendNotification`)
- **Variables**: camelCase (`$domainName`, `$userId`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_DOMAINS`, `PATH_ROOT`)
- **Database tables**: snake_case (`domains`, `notification_groups`, `notification_logs`)
- **Database columns**: snake_case (`domain_name`, `created_at`, `user_id`)

## File Naming

- Controllers: `{Name}Controller.php` (e.g., `DomainController.php`)
- Models: `{Name}.php` (e.g., `Domain.php`, `User.php`)
- Services: `{Name}Service.php` (e.g., `WhoisService.php`)
- Helpers: `{Name}Helper.php` (e.g., `DomainHelper.php`)
- Views: `{resource}/{action}.php` (e.g., `domains/index.php`, `domains/edit.php`)

## Important Paths

- **Web root**: `public/` (only this directory should be web-accessible)
- **Entry point**: `public/index.php`
- **Environment**: `.env` (root directory, not in git)
- **Logs**: `logs/` (writable by web server)
- **Cache**: `cache/` (writable by web server)
- **Uploads**: `public/uploads/` (user avatars, writable)

## Security Considerations

- Web server must point to `public/` directory only
- `.env` file must not be web-accessible
- All SQL queries use prepared statements
- CSRF tokens required for POST requests
- Session data stored in database (not files)
- User input sanitized via `htmlspecialchars()` and validation helpers
