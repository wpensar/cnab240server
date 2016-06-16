FROM ubuntu:14.04
    MAINTAINER Suporte WPensar <suporte@wpensar.com.br>

# Install basic tools
RUN apt-get update \
  && apt-get install -y \
  bc \
  curl \
  git \
  rsync \
  sudo \
  wget \
  && apt-get clean


# Install multistrap and dependencies
RUN apt-get -y install \
  gpgv \
  multistrap \
  perl-base \
  && apt-get clean

