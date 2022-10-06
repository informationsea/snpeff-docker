FROM alpine:3.16 AS download-bcftools
RUN apk add curl libarchive-tools
ARG BCFTOOLS_VERSION=1.16
RUN curl -OL https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2
RUN bsdtar xf bcftools-${BCFTOOLS_VERSION}.tar.bz2

FROM alpine:3.16 AS buildenv-bcftools
RUN apk add gcc make libc-dev ncurses-dev bzip2-dev zlib-dev curl-dev curl xz-dev
ARG BCFTOOLS_VERSION=1.16
COPY --from=download-bcftools /bcftools-${BCFTOOLS_VERSION} /bcftools-${BCFTOOLS_VERSION}
WORKDIR /bcftools-${BCFTOOLS_VERSION}
RUN ./configure --prefix=/usr
RUN make -j4
RUN make install DESTDIR=/dest

FROM alpine:3.16 AS download-htslib
RUN apk add curl libarchive-tools
ARG HTSLIB_VERSION=1.16
RUN curl -OL https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2
RUN bsdtar xf htslib-${HTSLIB_VERSION}.tar.bz2

FROM alpine:3.16 AS buildenv-htslib
RUN apk add gcc make libc-dev ncurses-dev bzip2-dev zlib-dev curl-dev curl xz-dev
ARG HTSLIB_VERSION=1.16
COPY --from=download-htslib /htslib-${HTSLIB_VERSION} /htslib-${HTSLIB_VERSION}
WORKDIR /htslib-${HTSLIB_VERSION}
RUN ./configure --prefix=/usr
RUN make -j4
RUN make install DESTDIR=/dest

FROM alpine:3.16 as extract-snpeff
RUN apk add unzip
WORKDIR /work
COPY snpEff_latest_core.zip /work
RUN unzip snpEff_latest_core.zip

FROM alpine:3.16
RUN apk add --no-cache bash openjdk17-jre nss ncurses libbz2 zlib libcurl xz-libs
COPY --from=buildenv-bcftools /dest /
COPY --from=buildenv-htslib /dest /
COPY --from=extract-snpeff /work/snpEff /opt/snpEff
ENV JAVA_OPTIONS -Xmx4g
ARG DB_VERSION=GRCh38.p14
RUN echo 'java ${JAVA_OPTIONS} -jar /opt/snpEff/snpEff.jar "${@}"' > /usr/bin/snpEff && chmod +x /usr/bin/snpEff && \
    echo 'java ${JAVA_OPTIONS} -jar /opt/snpEff/SnpSift.jar "${@}"' > /usr/bin/SnpSift && chmod +x /usr/bin/SnpSift && \
    snpEff download ${DB_VERSION}

ADD run.sh /run.sh
ENTRYPOINT [ "/bin/bash", "/run.sh" ]