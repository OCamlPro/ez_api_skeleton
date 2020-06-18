PROJECT_NAME:=skeleton
DATABASE:=skeleton
WEB_HOST:=http://localhost:8888
API_HOST:=http://localhost:8080
API_PORT:=8080
RLS_DIR:=www
CONTACT_EMAIL:=
VERSION:=1.0

-include Makefile.config

.EXPORT_ALL_VARIABLES:

PGDATABASE=$(DATABASE)

all: build website api-server openapi

db-updater:
	@dune build src/db/db-update

config/db-version.txt:
	@mkdir -p config
	@echo 0 > config/db-version.txt

db-update: config/db-version.txt db-updater
	@_build/default/src/db/db-update/db_updater.exe --witness config/db-version.txt --database $(PGDATABASE)

build: db-update
	dune build --profile release

website:
	@mkdir -p www
	@cp -f _build/default/src/ui/main_ui.bc.js www/$(PROJECT_NAME)-ui.js
	@rsync -ar static/* www
	@cp config/info.json www
	@sed -i 's/%{project_name}/$(PROJECT_NAME)/g' www/index.html

api-server: _build/default/src/api/api_server.exe
	@mkdir -p bin
	@cp -f _build/default/src/api/api_server.exe bin/api-server

release:
	@sudo cp -r www/* $(RLS_DIR)

clean:
	@dune clean

install:
	@dune install

build-deps:
	@opam install --deps-only .

config:
	@mkdir -p config
	@echo "{\"apis\": [\"$(API_HOST)\"]}" > config/info.json
	@echo "{\"port\": $(API_PORT)}" > config/api_config.json

init: build-deps config

git-init:
	rm -rf .git
	git init

openapi: _build/default/src/api/openapi.exe
	@_build/default/src/api/openapi.exe --version $(VERSION) --title "$(PROJECT_NAME) API" --contact "$(CONTACT_EMAIL)" --servers "api" $(API_HOST) -o www/openapi.json
