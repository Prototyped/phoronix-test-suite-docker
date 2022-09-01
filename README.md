## phoronix-test-suite-docker

This is a container image build for the [Phoronix Test Suite](https://www.phoronix-test-suite.com/) and, in particular,
installs a number of tests out of the box. The [official container image](https://hub.docker.com/r/phoronix/pts/) only
drops you onto the PTS shell and expects you to install the tests at runtime which I feel is not best practice.

This container build installs the following processor-oriented tests and their dependencies:

- pts/build-linux-kernel
- pts/x264
- pts/compress-xz
- pts/openssl
- pts/encode-flac
- pts/graphics-magick-2.1.0
- pts/compress-pbzip2
- pts/build-mplayer
- pts/gcrypt
- pts/stream

Note that, as of this writing, one test always fails (pts/build-linux-kernel's `allmodconfig` test) so should be
ignored.

The built container requires about 13 GB of disk space once built, and requires more space during the run. I recommend
at least 64 GB of disk space to be comfortable.

### How to build
Run

```shell
docker build -t gurdasani.com/benchmarks/phoronix-test-suite-docker:latest .
```

After the container build, it should be visible in the output of

```shell
docker images
```

### How to use

Run

```shell
mkdir pts-home
docker run --rm --cap-add SYS_NICE -itv "`pwd`/pts-home" gurdasani.com/benchmarks/phoronix-test-suite-docker:latest
```

### How to clean up

Run

```shell
docker rmi gurdasani.com/benchmarks/phoronix-test-suite-docker:latest
rm -rf pts-home
```

