SHELL := /bin/bash

export BASEDIR
BASEDIR := $(CURDIR)

all: help
  . : multistrap docker-image docker-shell build builder-shell release clean rmi-all rm-all re

#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# # And add help text after each target name starting with '\#\#'
# # A category can be added with @category
# HELP_FUN = \
  #   %help; \
  #     while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target] <param>\n\n"; \
      print "WP  Developer Tools\n\n"; \
        for (sort keys %help) { \
          print "${WHITE}$$_:${RESET}\n"; \
            for (@{$$help{$$_}}) { \
              $$sep = " " x (32 - length $$_->[0]); \
                print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
                  }; \
                    print "\n"; }

help: ##@other Show this help.
    @perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

# Docker Settings
# ##
# install: check-root ##@Settings Install Docker, Docker-Machine, Docker-Compose
#   @echo 'Installing docker..'
#     wget -qO- https://get.docker.com/ | sh
#       @echo 'Installing docker-machine...'
#         curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine
#           @echo 'Installing docker-compose...'
#             curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
#               hash -r
#
#               uninstall: check-root kill-them-all ##@Settings kill-them-all and Desinstall/Remove All Docker Files
  @apt-get remove -y docker-engine
    @apt-get remove -y --auto-remove docker-engine
      @apt-get purge -y docker-engine
        @apt-get purge -y --auto-remove docker-engine

  @echo "Removing docker binaries..."
    rm -f /usr/local/bin/docker*
      rm -rf ~/.docker*
        groupdel docker
          hash -r

# Docker-Machine
# ##
# certs: ##@docker-machine make certs <machine> - docker-machine regenerate-certs <machine>
#   $(if $(filter-out $@, $(MAKECMDGOALS)), @docker-machine regenerate-certs $(filter-out $@, $(MAKECMDGOALS)), @echo 'make regenerate-certs <machine>')
#
#     up: ##@docker-machine make up <machine> - docker-machine create --driver virtualbox <machine>
  $(if $(filter-out $@, $(MAKECMDGOALS)), @docker-machine create --driver virtualbox $(filter-out $@, $(MAKECMDGOALS)) || docker-machine regenerate-certs -f $(filter-out $@, $(MAKECMDGOALS)), @echo 'make up <machine>')

down: ##@docker-machine make down <machine> - docker-machine rm <machine>
    $(if $(filter-out $@, $(MAKECMDGOALS)), @docker-machine rm $(filter-out $@, $(MAKECMDGOALS)), @echo 'make up <machine>')

start: ##@docker-machine make start <machine> - docker-machine start <machine>
    $(if $(filter-out $@, $(MAKECMDGOALS)), @docker-machine start $(filter-out $@, $(MAKECMDGOALS)), @echo 'make start <machine>')
      $(if $(filter-out $@, $(MAKECMDGOALS)), @docker-machine env $(filter-out $@, $(MAKECMDGOALS)),)

stop: ##@docker-machine make stop <machine> - docker-machine stop <machine>
    $(if $(filter-out $@, $(MAKECMDGOALS)), @docker-machine stop $(filter-out $@, $(MAKECMDGOALS)), @echo 'make stop <machine>')

set: ##@docker-machine make set <machine> - docker-machine env <machine>
    $(if $(filter-out $@, $(MAKECMDGOALS)), @docker-machine env $(filter-out $@, $(MAKECMDGOALS)), @echo 'make set <machine>')
dns: ##@docker-machine make dns - fix dns
    $(if $(shell docker-machine ls -q), docker-machine  ssh default 'echo "nameserver 8.8.8.8" > /etc/resolv.conf', @echo 'Nothing to do here.')
ls: ##@docker-machine make ls - docker-machine ls
    @docker-machine ls

# Docker
# ##
# rm: ##@docker-container Delete all containers - docker rm -f `docker ps -a -q`
#   $(if $(shell docker ps -a -q), @docker rm -f $(shell docker ps -a -q), @echo 'Nothing to do here.')
#
#   rmi: ##@docker-container Delete all images - docker rmi -f `docker images -a -q`
  $(if $(shell docker images -q), @docker rmi -f $(shell docker images -q), @echo 'Nothing to do here.')

img: ##@docker-container List all docker images - docker images -a
    @docker images -a

ps: ##@docker-container List all docker containers - docker ps -a
    @docker ps -a

kill-them-all: ##@docker-container Kill Them All - Delete all Containers, Images and Machines
    $(if $(shell docker ps -a -q), @docker rm -f $(shell docker ps -a -q), @echo 'Nothing to do here.')
      $(if $(shell docker images -q), @docker rmi -f $(shell docker images -q), @echo 'Nothing to do here.')
        $(if $(shell docker-machine ls -q), @docker-machine rm -f $(shell docker-machine ls -q), @echo 'Nothing to do here.')

shell: padrao ## shell wpensar/padrao
    @docker run -it --rm wpensar/padrao

padrao: ## build wpensar/padrao
    docker build -t wpensar/padrao .

check-root:
    @export USER=`whoami`
      @if [ "$(USER)" != "root" ] ; then \
            echo "Hey fellow user, try again using sudo!" ; \
                exit 1; \
                  else \
                      echo "Hey ho let's go..."; \
                        fi

envs:
    @env|grep DOCKER

action:
    @echo  $(filter-out $@,$(MAKECMDGOALS))

%:
    @:
