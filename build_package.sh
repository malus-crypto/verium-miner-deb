#!/bin/bash

docker build -t verium-miner-deb:18.04 .
CID=$(docker create verium-miner-deb:18.04)
docker cp ${CID}:/pkg.deb ./pkg.deb
docker rm ${CID}
