# Skeleton

Skeleton is a template of website using API REST with a postgresql DB and writter in OCaml.

## Setup

You need to have postgresql installed (>= 9.5).
You need to have a working setup of opam/ocaml (>=4.08.1): [Manual](https://opam.ocaml.org/doc/Install.html), with sandbox mode disabled ([article](https://camlspotter.gitlab.io/blog/2019-04-16-pgocaml/)) for postgresql to be working.
In postgresql you should have a user with the same name as your computer user, with some specific rights:
```
sudo -i -u postgres
psql
CREATE USER <user>;
ALTER ROLE <user> CREATEDB;
ALTER ROLE <user> SET search_path TO db, public;
```

## Building Dependencies

```
make init
```

## Project Configuration

You can set up your project configuration (name, web server ports, ect..) by creating a file Makefile.config with these optional fields:
```
PROJECT_NAME=skeleton              # name of your project
DATABASE:=skeleton                 # name of your database
WEB_HOST:=http://localhost:8888    # external address of your WEB server
API_HOST:=http://localhost:8080    # external address of your API server
API_PORT:=8080                     # internal port of your API server
RLS_DIR:=www                       # release folder (/var/www/...)
CONTACT_EMAIL:=                    # email address displayed on API doc
VERSION:=1.0                       # API version displayed on API doc
```

After this configuration, you can build some JSON files used by the servers by doing:
```
make config
```

## Building

```
make
```

If you need to release your files on the /var/www/... folder, you can also run:
```
make release
```

## Launching

To launch the API server:
```
./bin/api-server config/api_conf.json
```
There are also some useful bash script or service to run the API server in the scripts folder

To test the web server on your localhost, you can use:
```
cd www
php -S localhost:8888     # if you didn't change the WEB_HOST variable
```
