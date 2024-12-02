FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	python3-pip \
	python3-venv \
	&& rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV="/python-env"

RUN python3 -m venv ${VIRTUAL_ENV}

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

