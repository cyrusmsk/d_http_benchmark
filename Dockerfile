FROM debian:bookworm AS build

RUN apt-get -qq update
RUN apt-get -qy install build-essential wget openssl ldc dub libssl-dev zlib1g-dev

RUN mkdir /usr/src/app

ADD handy_example /usr/src/app

WORKDIR /usr/src/app

ENV DC=ldc2
RUN dub build -b release --compiler=ldc2 --verbose

FROM debian:bookworm

WORKDIR /opt/web

RUN apt-get -qq update && apt-get -qy install openssl wget ldc

COPY --from=build /usr/src/app/server /opt/web/server

CMD /opt/web/server
