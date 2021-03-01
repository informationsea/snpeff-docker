#!/bin/bash

sed -e 's/__GENOME_VERSION__/GRCh38.p13/' Dockerfile-template | \
    sed -e 's/__GENCODE_VERSION__/37/' | sed -e 's/__DOWNLOAD_PREFIX__//' | \
    sed -e 's/__GENCODE_TYPE__/.basic/' \
    > Dockerfile.GENCODE37.GRCh38.p13.basic

sed -e 's/__GENOME_VERSION__/GRCh37.primary_assembly/' Dockerfile-template | \
    sed -e 's/__GENCODE_VERSION__/37/' | sed -e 's|__DOWNLOAD_PREFIX__|GRCh37_mapping/|' | \
    sed -e 's/__GENCODE_TYPE__/lift37.basic/' \
    > Dockerfile.GENCODE37.GRCh37.primary_assembly.basic
