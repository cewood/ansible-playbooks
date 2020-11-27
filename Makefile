ANSIBLE_KEEP_REMOTE_FILES = $(or $(shell printenv ANSIBLE_KEEP_REMOTE_FILES),0)
DOCKER_INTERACTIVE        = $(if $(shell printenv GITHUB_ACTIONS),-t,-it)
GID                       = $(or $(shell printend GID), $(shell id -g))
GIT_REVISION              = $(or $(shell printenv GIT_REVISION), $(shell git describe --match= --always --abbrev=7 --dirty))
GROUP                     = $(or $(shell printend GROUP), $(shell id -g -n))
HOME                      = $(shell printenv HOME)
PLAYBOOKS                 = $(shell find . -name playbook.yml)
UID                       = $(or $(shell printenv UID), $(shell id -u))
USER                      = $(or $(shell printenv USER), $(shell id -u -n))
VERSION                   = snapshot


.PHONY: syntax
syntax:
	ansible-playbook \
	  --syntax-check \
	  -vv \
	  -i inventory.yml \
	  $(or ${ARGS},${PLAYBOOKS})

.PHONY: syntax-docker
syntax-docker: docker-do-syntax


.PHONY: vendor
vendor:
	ansible-galaxy \
	  install \
	  --verbose \
	  --force \
	  -r requirements.yml

.PHONY: vendor-docker
vendor-docker: docker-do-vendor


.PHONY: lint
lint:
	ansible-lint $(or ${ARGS},${PLAYBOOKS})

.PHONY: lint-docker
lint-docker: docker-do-lint


.PHONY: check
check:
	ansible-playbook \
	  --check \
	  --diff \
	  -i inventory.yml \
	  ${ARGS}

.PHONY: check-docker
check-docker: docker-do-check


.PHONY: run
run:
	ansible-playbook \
	  --diff \
	  -i inventory.yml \
	  ${ARGS}

.PHONY: run-docker
run-docker: docker-do-run


.PHONY: docker-do-%
docker-do-%: .dockerimage
	docker run --rm \
	  ${DOCKER_INTERACTIVE} \
	  -e ANSIBLE_KEEP_REMOTE_FILES=${ANSIBLE_KEEP_REMOTE_FILES} \
	  -e HOME=/homedir \
	  -e SSH_AUTH_SOCK=/var/run/ssh-agent.sock \
	  -v ${HOME}/.ssh:/homedir/.ssh:ro \
	  -v ${SSH_AUTH_SOCK}:/var/run/ssh-agent.sock \
	  -v ${PWD}:/workdir:ro \
	  -w /workdir \
	  ansible \
	  make $* ARGS="${ARGS}"


.dockerimage: Dockerfile
	docker \
	  build \
	  --build-arg GID=${GID} \
	  --build-arg GROUP=${GROUP} \
	  --build-arg UID=${UID} \
	  --build-arg USER=${USER} \
	  -t ansible .
	touch .dockerimage
