#! /bin/bash
# Copyright 2022-present Kuei-chun Chen. All rights reserved.
die() { echo "$*" 1>&2 ; exit 1; }
VERSION="v$(cat version)-$(date "+%Y%m%d")"
REPO=$(basename "$(dirname "$(pwd)")")/$(basename "$(pwd)")
LDFLAGS="-X main.version=$VERSION -X main.repo=$REPO"
TAG="simagix/hatchet"
[[ "$(which go)" = "" ]] && die "go command not found"

gover=$(go version | cut -d' ' -f3)
if [ "$gover" \< "go1.18" ]; then
    [[ "$GOPATH" = "" ]] && die "GOPATH not set"
    [[ "${GOPATH}/src/github.com/$REPO" != "$(pwd)" ]] && die "building hatchet should be under ${GOPATH}/src/github.com/$REPO"
fi

if [ ! -f go.sum ]; then
    go mod tidy
fi

mkdir -p dist
rm -f ./dist/hatchet
go build -ldflags "$LDFLAGS" -o ./dist/hatchet main/hatchet.go
if [[ -f ./dist/hatchet ]]; then
  ./dist/hatchet -version
fi

