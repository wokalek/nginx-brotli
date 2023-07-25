ARG ALPINE_VERSION=3.18.2
ARG NGINX_VERSION=1.25.1
ARG PCRE2_VERSION=10.42
ARG BROTLI_COMMIT=6e975bcb015f62e1f303054897783355e2a877dc

FROM alpine:$ALPINE_VERSION AS build

ARG NGINX_VERSION
ARG PCRE2_VERSION
ARG BROTLI_COMMIT

WORKDIR /src

RUN  apk add --no-cache \
  git \
  make \
  gcc \
  openssl-dev \
  zlib-dev \
  linux-headers \
  g++

RUN \
    # Brotli
    mkdir ngx_brotli && \
    cd ngx_brotli && \
    git init && \
    git remote add origin https://github.com/google/ngx_brotli.git && \
    git fetch --depth 1 origin $BROTLI_COMMIT && \
    git checkout FETCH_HEAD && \
    git submodule update --init --recursive --depth 1 && \
    cd .. && \
    # PCRE2
    wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VERSION/pcre2-$PCRE2_VERSION.tar.gz && \
    tar xvf pcre2-$PCRE2_VERSION.tar.gz && \
    # Nginx
    wget https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    tar xvf nginx-$NGINX_VERSION.tar.gz && \
    # Nginx build
    cd nginx-$NGINX_VERSION && \
    ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_v3_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-pcre=/src/pcre2-$PCRE2_VERSION \
    --with-pcre-jit \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --add-module=/src/ngx_brotli && \
    make && \
    make install

FROM alpine:$ALPINE_VERSION

COPY --from=build /usr/sbin/nginx /usr/sbin
COPY --from=build /etc/nginx /etc/nginx

RUN \
	addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G users -u 1000 user \
	# forward request and error logs to docker log collector
	&& mkdir /var/log/nginx \
	&& touch /var/log/nginx/access.log /var/log/nginx/error.log \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
