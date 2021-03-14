#!/bin/sh
set -e

APP_NAME=$(grep DOCKER_APP_NAME .env | cut -d '=' -f2)-app

echo "Deploying application ..."

# Enter maintenance mode
(docker exec ${APP_NAME} php artisan down) || true
    # Update codebase
    git fetch origin production
    git reset --hard origin/production

    # Install dependencies based on lock file
    docker exec ${APP_NAME} /usr/local/bin/composer install

    # Installing any npm dependencies
    docker exec ${APP_NAME} npm install

    # Compiling assets
    docker exec ${APP_NAME} npm run production

    # Migrate database
    docker exec ${APP_NAME} php artisan migrate --force
# Exit maintenance mode
docker exec ${APP_NAME} php artisan up

echo "Application deployed!"