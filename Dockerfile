FROM hamub/django:v2
# Let us copy our requirements file so that we can install our python dependencies.
ADD requirements.txt /requirements.txt

RUN set -ex \
    && apk add --no-cache --virtual \
    libpq-dev \
    jpeg-dev \
    zlib-dev \
    postgresql-dev \
    musl-dev \
    libgcc \
    gcc \
    nginx
RUN pip install -U pip \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "pip install -U  --no-cache-dir -r requirements.txt --timeout 120 " \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "pip install -U  --no-cache-dir django==1.11 --timeout 120 "
# Set the project directory for the source code to:  /home/django
WORKDIR /home/django/
RUN rm /etc/nginx/conf.d/default.conf 
    # && mkdir -p /home/django/dist
COPY conf/nginx-app.conf /etc/nginx/conf.d/default.conf
# Copy our source code to the working directory
ADD .  /home/django
EXPOSE 80
# Run migrations, collectstatic, start uwsgi .... e.t.c
CMD ["/home/django/run-prod.sh"]
