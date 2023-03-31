#!/usr/bin/env bash

GO_VERSION=1.20

set -euxo pipefail

if [ -d pkg ]; then
    rm -rf pkg
fi
if [ -f go.sum ]; then
    rm go.sum
fi
if [ -f go.mod ]; then
    rm go.mod
fi
if [ -f LICENSE ]; then
    rm LICENSE
fi

git clone --depth 1 https://github.com/golang/tools tmp
SOURCE=tmp

mkdir -p pkg/lsp

cp -R $SOURCE/internal/jsonrpc2 pkg/jsonrpc2
cp -R $SOURCE/internal/jsonrpc2_v2 pkg/jsonrpc2_v2
cp -R $SOURCE/internal/bug pkg/bug
cp -R $SOURCE/internal/event pkg/event
cp -R $SOURCE/internal/stack pkg/stack
cp -R $SOURCE/internal/xcontext pkg/xcontext
cp -R $SOURCE/internal/testenv pkg/testenv
cp -R $SOURCE/internal/goroot pkg/goroot

cp -R $SOURCE/gopls/internal/lsp/protocol pkg/lsp/protocol
cp -R $SOURCE/gopls/internal/lsp/safetoken pkg/lsp/safetoken
cp -R $SOURCE/gopls/internal/span pkg/span

find pkg/ -type f -name '*.go' -exec sed -i '' -e 's#golang\.org/x/tools/gopls/internal#github\.com/laytan/go-lsp-protocol/pkg#g' {} \;
find pkg/ -type f -name '*.go' -exec sed -i '' -e 's#golang\.org/x/tools/internal#github\.com/laytan/go-lsp-protocol/pkg#g' {} \;

cp $SOURCE/LICENSE LICENSE

echo -en "module github.com/laytan/go-lsp-protocol\n\ngo $GO_VERSION\n" > go.mod
go mod tidy

rm -rf tmp
