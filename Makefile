PROJECT_NAME:=skeleton
DATABASE:=skeleton
WEB_HOST:=http://localhost:8888
RLS_DIR:=www

-include Makefile.config

all: build website

build: project-db-update
	PGDATABASE=$(DATABASE) dune build
	cp -u _build/default/src/api/api_server.exe api-server
	chmod +w api-server

website:
	mkdir -p www
	cp -f _build/default/src/ui/main_ui.bc.js www/$(PROJECT_NAME)-ui.js
	rsync -arv static/* www

submodule:
	git submodule init
	git submodule update

release:
	sudo cp -r www/* $(RLS_DIR)

clean:
	dune clean

install:
	dune install

project-db-updater:
	PGDATABASE=$(DATABASE) dune build src/db

project-db-update: project-db-updater
	$(MAKE) db-update

DBUPDATER=_build/default/src/db/db_updater.exe
DBWITNESS=--witness db-version.txt
DBNAME=--database $(DATABASE)
-include libs/ez-pgocaml/libs/ez-pgocaml/Makefile.ezpg
