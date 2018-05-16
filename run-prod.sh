#!/bin/sh

cd /home/django/
touch /run/nginx/nginx.pid
chmod +x /run/nginx/nginx.pid
python manage.py makemigrations --noinput
python manage.py migrate --noinput
python manage.py collectstatic --noinput


uwsgi --ini conf/app.ini
nginx

