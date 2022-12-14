FROM public.ecr.aws/debian/debian:bookworm-slim as staging

COPY phoronix-test-suite.xml /etc/phoronix-test-suite.xml

RUN set -eu; \
    PHORONIX_TEST_SUITE_VERSION=10.8.4; \
    PHORONIX_TEST_SUITE_DEB=phoronix-test-suite_${PHORONIX_TEST_SUITE_VERSION}_all.deb; \
    DEBIAN_FRONTEND=noninteractive; \
    export DEBIAN_FRONTEND; \
    apt -y update; \
    apt -y install ca-certificates; \
    echo deb https://www-uxsup.csx.cam.ac.uk/pub/linux/debian/ bookworm main contrib non-free > /etc/apt/sources.list; \
    echo deb-src https://www-uxsup.csx.cam.ac.uk/pub/linux/debian/ bookworm main contrib non-free >> /etc/apt/sources.list; \
    echo deb https://cdn-aws.deb.debian.org/debian-security/ testing-security main contrib non-free >> /etc/apt/sources.list; \
    echo deb-src https://cdn-aws.deb.debian.org/debian-security/ testing-security main contrib non-free >> /etc/apt/sources.list; \
    apt -y update; \
    apt -y dist-upgrade; \
    apt -y autoremove; \
    apt -y autoclean; \
    apt -y install tzdata locales-all aptitude curl tini unzip libelf-dev; \
    ln -sf /etc/zoneinfo/Etc/UTC /etc/localtime; \
    apt -y install locales; \
    update-locale LANG=en_GB.UTF-8; \
    aptitude -y install php-cli php-xml; \
    apt -y build-dep aircrack-ng; \
    curl --fail-with-body -LSso /tmp/${PHORONIX_TEST_SUITE_DEB} https://phoronix-test-suite.com/releases/repo/pts.debian/files/${PHORONIX_TEST_SUITE_DEB}; \
    dpkg -i /tmp/${PHORONIX_TEST_SUITE_DEB}; \
    apt -y clean; \
    rm -rf /var/cache/apt/archives/* /tmp/${PHORONIX_TEST_SUITE_DEB}; \
    phoronix-test-suite batch-install pts/build-linux-kernel pts/x264 pts/compress-xz pts/openssl pts/encode-flac pts/graphics-magick-2.1.0 pts/compress-pbzip2 pts/build-mplayer pts/gcrypt pts/stream; \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*.*; \
    find /var/lib/phoronix-test-suite/installed-tests -type f \( -name \*.tar.bz2 -o -name \*.tar.gz -o -name \*.tar.xz -o -name \*.7z -o -name \*.zip \) \! -path \*build-\* -print0 | xargs -0 rm -f

ENTRYPOINT ["tini", "--", "chrt", "99", "phoronix-test-suite", "batch-run", "pts/build-linux-kernel", "pts/build-mplayer", "pts/compress-bzip2", "pts/compress-xz", "pts/encode-flac", "pts/gcrypt", "pts/openssl", "pts/stream", "pts/x264", "pts/graphics-magick-2.1.0"]
WORKDIR /root
USER 0:0
VOLUME /root

