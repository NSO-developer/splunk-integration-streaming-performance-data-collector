FROM golang:1.22 AS build

WORKDIR /src
ADD . /src

RUN rm -rf /usr/local/go;wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz &&  tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz && export PATH=$PATH:/usr/local/go/bin
RUN echo "export PATH=$PATH:/usr/local/go/bin" > ~/.bashrc
RUN  export PATH=$PATH:/usr/local/go/bin; make otelcontribcol

FROM alpine:latest as certs
RUN apk --update add ca-certificates

FROM scratch

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /src/bin/otelcontribcol_linux_amd64 /otelcontribcol
ENTRYPOINT ["/otelcontribcol"]
EXPOSE 4317 4318 55680 55679
