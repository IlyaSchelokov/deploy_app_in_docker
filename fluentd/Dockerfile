# fluentd/Dockerfile

FROM fluentd:v1.18.0-debian-1.0

USER root

RUN ["fluent-gem", "install", "elasticsearch", "--version", "8.17.0"]

RUN apt-get update && apt-get install -y curl

RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "5.4.3"]

USER fluent
