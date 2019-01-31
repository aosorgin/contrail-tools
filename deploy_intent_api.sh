#!/usr/bin/env bash

set -o errexit

yum -y install wget unzip

# Collect golang
pushd /tmp
wget https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.11.5.linux-amd64.tar.gz
rm go1.11.5.linux-amd64.tar.gz
popd

# Setup golang environment
GOROOT=/usr/local/go
GOPATH=$HOME/go

cat >>$HOME/.bash_profile <<EOF

# Golang environment
GOROOT=$GOROOT
export GOROOT

GOPATH=$GOPATH
export GOPATH

export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
EOF

source $HOME/.bash_profile

# Collect github.com/Juniper/contrail.git
mkdir -p $HOME/go/src/github.com/Juniper
pushd $HOME/go/src/github.com/Juniper
git clone https://github.com/Juniper/contrail.git
pushd contrail

# Building and deploing contrail
go get -u github.com/golang/dep/cmd/dep
make check deps generate build
eval ./tools/deploy-for_k8s.sh
popd
popd