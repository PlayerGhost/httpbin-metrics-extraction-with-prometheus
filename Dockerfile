FROM python:3.7-alpine

ENV WEB_CONCURRENCY=4

ADD . /httpbin

RUN apk add -U ca-certificates libffi libstdc++ && \
    apk add --virtual build-deps build-base libffi-dev && \
    pip install greenlet && \
    pip install werkzeug==2.0.3 && \
    pip install flask && \
    pip install --no-cache-dir gunicorn /httpbin && \
    apk del build-deps && \
    rm -rf /var/cache/apk/*

EXPOSE 80

# Iniciar httpbin com exportação de métricas para Prometheus
CMD ["gunicorn", "--statsd-host=localhost:9125", "--statsd-prefix=httpbin", "-b", "0.0.0.0:80", "httpbin:app"]
