FROM ubuntu:24.04

# Include deb-src in sources.list files
RUN sed -i -e 's,Types: deb$,Types: deb deb-src,' /etc/apt/sources.list.d/ubuntu.sources

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get build-dep mesa -y \
	&& apt-get install -y \
		bison \
		cbindgen \
		cmake \
		curl \
		flex \
		libpciaccess-dev \
		ninja-build \
		pkg-config \
		python3-pip \
		python3-venv \
	&& rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV="/python-env"

RUN python3 -m venv ${VIRTUAL_ENV}

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# TODO(tmckee): make a requirements.txt file instead of listing packages here.
RUN pip3 install \
	Mako \
	PyYAML \
	meson \
	packaging \
	ply \
	;

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="$HOME/.cargo/bin/:$PATH"

# Right now, Ubuntu packages don't have libdrm-2.4.121+ in stable yet; we'll
# need to get it ourselves. T_T
ARG LIBDRM_VERSION=2.4.123
ENV LIBDRM_RELEASE_URL=https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM_VERSION}.tar.xz

RUN curl ${LIBDRM_RELEASE_URL} -o `basename ${LIBDRM_RELEASE_URL}` \
	&& tar -xf `basename ${LIBDRM_RELEASE_URL}` \
	&& cd `basename ${LIBDRM_RELEASE_URL} .tar.xz` \
	&& meson setup builddir \
	&& ninja -C builddir/ install \
	&& cd - \
	&& rm -rf \
		`basename ${LIBDRM_RELEASE_URL}` \
		`basename ${LIBDRM_RELEASE_URL} .tar.xz`

# ENRTYPOINT meson setup builddir
