#
# Golang dependencies build container
#
FROM golang:stretch

#
# Build SFTPgo
#

WORKDIR /go

RUN go get -d github.com/drakkan/sftpgo \
    && cd src/github.com/drakkan/sftpgo \
    && go build -i -ldflags "-s -w -X github.com/drakkan/sftpgo/utils.commit=`git describe --always --dirty` -X github.com/drakkan/sftpgo/utils.date=`date -u +%FT%TZ`" -o sftpgo \
    && chmod a+x sftpgo \
    && mv sftpgo /usr/local/bin \
    && rm -rf /go/src

# Installs into:
# - /usr/local/bin/sftpgo

#
# Build Jobber
#

WORKDIR /go

RUN apt-get update \
    && apt-get install -y --no-install-recommends rsync \
    && mkdir -p src/github.com/dshearer \
    && cd src/github.com/dshearer \
    && git clone https://github.com/dshearer/jobber.git \
    && cd jobber \
    && make check \
    && make install DESTDIR=/ \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /go/src

# Installs into:
# - /usr/local/bin/jobber
# - /usr/local/libexec/jobbermaster
# - /usr/local/libexec/jobberrunner

#
# Build Dockerize
#

WORKDIR /go

RUN go get -d github.com/jwilder/dockerize \
    && cd src/github.com/jwilder/dockerize \
    && go build -i \
    && chmod a+x dockerize \
    && mv dockerize /usr/local/bin \
    && rm -rf /go/src

# Installs into:
# - /usr/local/bin/dockerize

#
# Build Roadrunner
# 

WORKDIR /go

RUN go get -d github.com/spiral/roadrunner \
    && cd src/github.com/spiral/roadrunner \
    && go mod download \
    && make \
    && chmod a+x rr \
    && mv rr /usr/local/bin \
    && rm -rf /go/src

# Installs into:
# - /usr/local/bin/rr