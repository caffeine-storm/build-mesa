FROM ubuntu:24.04

# Include deb-src in sources.list files
RUN sed -i -e 's,Types: deb$,Types: deb deb-src,' /etc/apt/sources.list.d/ubuntu.sources

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
		bison \
		flex \
		python3-pip \
		python3-venv \
	&& apt-get build-dep -y \
		mesa \
	&& rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV="/python-env"

RUN python3 -m venv ${VIRTUAL_ENV}

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# TODO(tmckee): make a requirements.txt file instead of listing packages here.
RUN pip3 install \
	Mako \
	meson \
	packaging
