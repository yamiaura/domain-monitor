#!/bin/bash
set -e

# Wait for database to be ready
echo "Waiting for database connection..."
until php -r "new PDO('mysql:host=${DB_HOST};dbname=${DB_DATABASE}', '${DB_USERNAME}', '${DB_PASSWORD}');" 2>/dev/null; do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "Database is up - continuing"

# Start cron in background
echo "Starting cron service..."
cron

# Execute the main container command
exec "$@"
