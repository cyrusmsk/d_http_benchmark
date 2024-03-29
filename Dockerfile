FROM debian:bookworm AS build

RUN apt-get -qq update
RUN apt-get -qy install build-essential openssl ldc dub libssl-dev zlib1g-dev

RUN mkdir /usr/src/app

ADD servers/serverino /usr/src/app

WORKDIR /usr/src/app

ENV DC=ldc2
RUN dub build -b release-nobounds --compiler=ldc2 --force

FROM debian:bookworm

WORKDIR /opt/web

RUN apt-get -qq update && apt-get -qy install openssl ldc

COPY --from=build /usr/src/app/server /opt/web/server

CMD /opt/web/server
