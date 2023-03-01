#!/bin/bash

composer install;
php artisan migrate;
php artisan key:generate;
php artisan passport:install;
php artisan db:seed;
php artisan storage:link;