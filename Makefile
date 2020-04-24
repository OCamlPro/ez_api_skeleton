PROJECT_NAME:=skeleton
DATABASE:=skeleton
DB_HOST:=/var/run/postgresql
RLS_DIR:=www
WITH_VERSION:=false

-include Makefile.config

all: db-updater
	$(MAKE) BASE64_3=true -C libs/ocplib-jsutils base64-conf
	PGDATABASE=$(DATABASE) ocp-build
	cp -f _obuild/api-server/api-server.asm api-server
	$(MAKE) website

db-updater: write-config
	$(MAKE) db-update

write-config:
	@echo Updating ocp-autoconf.d/config.ocp2inc
	@mkdir -p ocp-autoconf.d
	@echo "(* Automatically generated from Makefile + Makefile.database *)" > ocp-autoconf.d/config.ocp2inc
	@echo "project_name=\"$(PROJECT_NAME)\";" >> ocp-autoconf.d/config.ocp2inc
	@echo "with_version=$(WITH_VERSION);" >> ocp-autoconf.d/config.ocp2inc

website:
	mkdir -p www
	cp -f _obuild/$(PROJECT_NAME)-ui/$(PROJECT_NAME)-ui.js www
	rsync -arv static/* www

submodule:
	git submodule init
	git submodule update

build-deps: opam
	opam install --deps-only .

init: configure
	ocp-build init

clean:
	ocp-build clean

conf: submodule
	ocp-autoconf

configure: conf
	./configure

pgocaml-install:
	git clone git@github.com:darioteixeira/pgocaml.git libs/pgocaml
	opam install libs/pgocaml

ocp-build-install:
	git clone git@github.com:ocamlpro/ocp-build.git libs/ocp-build
	opam install libs/ocp-build

warnings:
	ocp-build --project-warnings

release:
	sudo cp -r www/* $(RLS_DIR)

DBUPDATER=db-updater
DBWITNESS=--witness db-version.txt
DBNAME=--database $(DATABASE)
DBSOCKETDIR=--socket-dir $(DB_HOST)
-include libs/ez-pgocaml/libs/ez-pgocaml/Makefile.ezpg
-include libs/ocplib-jsutils/ocp-autoconf.d/Makefile
