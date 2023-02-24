##? zephyr - A Zsh framework as nice as a cool summer breeze
##?
##?	Usage: make <command>
##?
##?	Commands:

.DEFAULT_GOAL := help
all : help build test
.PHONY : all

##?   build    run build tasks
build:
	./bin/build_prezto_plugins; \
  ./bin/build_starship_completions

##?   test    run tests
test:
	./bin/runtests

##?   help     show this message
help:
	@grep "^##?" makefile | cut -c 5-
