#!/bin/bash

sed -e 's/DB_VERSION/hg19/' Dockerfile-template > Dockerfile.hg19
sed -e 's/DB_VERSION/hg38/' Dockerfile-template > Dockerfile.hg38
sed -e 's/DB_VERSION/GRCh37.75/' Dockerfile-template > Dockerfile.GRCh37.75
sed -e 's/DB_VERSION/GRCh38.86/' Dockerfile-template > Dockerfile.GRCh38.86
sed -e 's/DB_VERSION/GRCh37.p13.RefSeq/' Dockerfile-template > Dockerfile.GRCh37.p13.RefSeq
sed -e 's/DB_VERSION/GRCh38.p7.RefSeq/' Dockerfile-template > Dockerfile.GRCh38.p7.RefSeq