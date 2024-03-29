ANSIBLE_KEEP_REMOTE_FILES = $(or $(shell printenv ANSIBLE_KEEP_REMOTE_FILES),0)
ANSIBLE_FLAGS             = $(or $(shell printenv ANSIBLE_FLAGS),--diff)
DOCKER_INTERACTIVE        = $(if $(shell printenv GITHUB_ACTIONS),-t,-t)
GID                       = $(or $(shell printend GID), $(shell id -g))
GIT_REVISION              = $(or $(shell printenv GIT_REVISION), $(shell git describe --match= --always --abbrev=7 --dirty))
GROUP                     = $(or $(shell printend GROUP), $(shell id -g -n))
HOME                      = $(shell printenv HOME)
PLAYBOOKS                 = $(shell find . -name playbook.yml)
UID                       = $(or $(shell printenv UID), $(shell id -u))
USER                      = $(or $(shell printenv USER), $(shell id -u -n))
VERSION                   = snapshot


.PHONY: check
check:
	$(MAKE) run \
	  ANSIBLE_FLAGS="--check --diff" \
	  ARGS="${ARGS}"

.PHONY: check-docker
check-docker:
	$(MAKE) docker-do-check \
	  ARGS="${ARGS}"

.PHONY: run
run:
	ansible-playbook \
	  ${ANSIBLE_FLAGS} \
	  -i inventory.yml \
	  ${ARGS}

.PHONY: run-docker
run-docker: docker-do-run

.PHONY: lint
lint:
	ansible-lint -v $(or ${ARGS},${PLAYBOOKS})

.PHONY: lint-docker
lint-docker: docker-do-lint

.PHONY: syntax
syntax:
	$(MAKE) run \
	  ANSIBLE_FLAGS="--syntax-check -vv" \
	  ARGS="$(or ${ARGS},${PLAYBOOKS})"

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

.PHONY: docker-do-%
docker-do-%: .dockerimage
	docker \
	  run \
	  --rm \
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
