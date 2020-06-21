FROM cytopia/ansible:2.9-0.25 AS ansible
FROM cytopia/ansible-lint:latest-release-0.5 AS lint


FROM ansible AS base

RUN apk add \
  make \
  openssh

ARG LINT_VERSION=4.1.0
RUN pip3 install --no-cache-dir --no-compile "ansible-lint==${LINT_VERSION}"

ARG GID
ARG GROUP
ARG UID
ARG USER
RUN mkdir /homedir /workdir \
  && chmod 777 /homedir /workdir \
  && addgroup -g $GID $GROUP \
  && adduser -D -H -u $UID -G $GROUP -h /homedir $USER

USER $USER
