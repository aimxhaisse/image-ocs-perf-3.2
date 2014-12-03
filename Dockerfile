## -*- docker-image-name: "armbuild/image-ocs-perf-3.2:utopic" -*-
FROM armbuild/ocs-distrib-ubuntu:utopic

# Prepare rootfs for image builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update &&	\
    apt-get -q upgrade && 	\
    apt-get install -y -q 	\
	    emacs23-nox		\
	    git			\
	    build-essential	\
	    wget		\
	    libdw-dev		\
	    libnewt-dev		\
	    python-dev		\
	    binutils-dev	\
    && apt-get clean

# Build iperf
RUN wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.64.tar.gz -O /tmp/linux.tar.gz	\
    && cd /tmp/ 							     			\
    && tar -xf linux.tar.gz									\
    && cd linux-3.2.64/tools/perf/								\
    && make DESTDIR=/usr -j5 && make install DESTDIR=/usr					\
    && cd /											\
    && rm -rf /tmp/linux*

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
