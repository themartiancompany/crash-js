# SPDX-License-Identifier: GPL-3.0-or-later

#    ----------------------------------------------------------------------
#    Copyright © 2024, 2025  Pellegrino Prevete
#
#    All rights reserved
#    ----------------------------------------------------------------------
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

SHELL ?= bash
_NPM ?= true
PREFIX ?= /usr/local
_PROJECT=crash-js
_PROJECT_NPM=$(_PROJECT)
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
USR_DIR=$(DESTDIR)$(PREFIX)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
LIB_DIR=$(DESTDIR)$(PREFIX)/lib/lib$(_PROJECT)
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
NODE_DIR=$(PREFIX)/lib/node_modules/$(_PROJECT)/$(_PROJECT)
AHSI_DIR=$(PREFIX)/lib/node_modules/ahsi
BUILD_NPM_DIR=build

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_EXE=\
  install \
    -vDm755
_INSTALL_DIR=\
  install \
    -vdm755

DOC_FILES=\
  $(wildcard \
      *.rst) \
  $(wildcard \
      *.md)
SCRIPT_FILES=\
  $(wildcard \
      $(_PROJECT)/*)
NPM_FILES=\
  "$(_PROJECT)" \
  "README.md" \
  "COPYING" \
  "AUTHORS.rst" \
  "dist" \
  "eslint.config.mjs" \
  "fs-worker.webpack.config.cjs" \
  "package.json" \
  "webpack.config.cjs"

all: build

check: eslint

eslint:

	npm \
	  run \
	    lint

install: install-scripts install-doc install-examples install-man

build:

	if [[ "$(_NPM)" == "false" ]]; then \
	  make \
	    build-webpack; \
	elif [[ "$(_NPM)" == "true" ]]; then \
	  make \
	    build-npm; \
	else \
	  echo \
	   "Invalid value for '$(_NPM)'." \
	   1>&2; \
	   exit \
	     1; \
	fi
	make \
	  build-man

install-scripts:

	if [[ "$(_NPM)" == "false" ]]; then \
	  $(_INSTALL_DIR) \
	    "$(LIB_DIR)/nodejs"; \
	  cp \
	    -r \
	    $$(printf \
	         "$${PWD}/%s " \
	         $$(cat \
	              "$${PWD}/package.json" | \
	              jq \
	                --raw-output \
	                '.files[]')) \
	    "$(LIB_DIR)/nodejs"; \
	  rm \
	    "$(LIB_DIR)/nodejs/node_modules" || \
	    true; \
	  ln \
	    -s \
	    "$(PREFIX)/lib/node_modules" \
	    "$(LIB_DIR)/nodejs/node_modules" || \
	    true; \
	  ln \
	    -s \
	    "$(PREFIX)/lib/lib$(_PROJECT)/nodejs/$(_PROJECT)/$(_PROJECT)" \
	    "$(LIB_DIR)/$(_PROJECT)" || \
	    true; \
	  ln \
	    -s \
	    "$(PREFIX)/lib/lib$(_PROJECT)/nodejs/$(_PROJECT)/fs-utils" \
	    "$(LIB_DIR)/fs-utils" || \
	    true; \
	  ln \
	    -s \
	    "$(PREFIX)/lib/lib$(_PROJECT)/nodejs/$(_PROJECT)/utils" \
	    "$(LIB_DIR)/utils" || \
	    true; \
	  rm \
	    -rf \
            "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)"; \
	  ln \
	    -s \
	    "$(PREFIX)/lib/lib$(_PROJECT)/nodejs" \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" || \
	    true; \
	elif [[ "$(_NPM)" == "true" ]]; then \
	  make \
	    install-npm; \
	  ln \
	   -s \
	    "$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" \
	    "$(LIB_DIR)/nodejs" || \
	  true; \
	fi

build-man:

	mkdir \
	  -p \
	  "build/man"
	rst2man \
	  "man/lib$(_PROJECT).1.rst" \
	  "build/man/lib$(_PROJECT).1"

build-webpack:

	$(INSTALL_DIR) \
	  "build/dist/crash-js"
	cp \
	  -r \
	  "$(_PROJECT)" \
	  "webpack.config.cjs" \
	  "build"
	_webpack=( \
	  "$$(command \
	        -v \
	        "webpack")"; \
	if [[ "${_webpack}" == "" ]]; then \
	  _webpack=(
	    npx
	      webpack); \
	fi; \
	cd \
	  "build"; \
        "${_webpack[@]}" \
	  --mode \
	    'production' \
	  --config \
	  'fs-worker.webpack.config.cjs' \
	  --stats-error-details; \
	mv \
	  'fs-worker.js' \
	  'dist/crash-js/fs-worker.js'; \
        "${_webpack[@]}" \
	  --mode \
	    'production' \
	  --config \
	    'webpack.config.cjs' \
	  --stats-error-details; \
	mv \
	  "$(_PROJECT).js" \
	  "dist/$(_PROJECT)"

build-npm:

	mkdir \
	  -p \
	  "build/man"
	rst2man \
	  "man/lib$(_PROJECT).1.rst" \
	  "build/lib$(_PROJECT).1"
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	cp \
	  -r \
	  $(NPM_FILES) \
	  "build"; \
	cd \
	  "build"; \
	npm \
	  install \
	    --save-dev; \
	npm \
	  install \
	    --include="optional"; \
	rm \
	  -rf \
	  "$(_PROJECT).js"; \
	npm \
	  run \
	    build; \
	npm \
	  pack; \
	mv \
	  "$(_PROJECT)-$${_version}.tgz" \
	  ".."

install-examples:

	cd \
	  "examples/ahsi"; \
	make \
	 all; \
	make \
	  install;

install-npm:

	_npm_opts=( \
	  -g \
	  --prefix \
	    "$(USR_DIR)" \
	); \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	npm \
	  install \
	    "$${_npm_opts[@]}" \
	    "$(_PROJECT)-$${_version}.tgz"; \
	$(_INSTALL_DIR) \
	  "$(LIB_DIR)"; \
	ln \
	  -s \
	  "$(NODE_DIR)/$(_PROJECT)" \
	  "$(LIB_DIR)/$(_PROJECT)" || \
	true; \
	ln \
	  -s \
	  "$(NODE_DIR)/fs-utils" \
	  "$(LIB_DIR)/fs-utils" || \
	true; \
	ln \
	  -s \
	  "$(NODE_DIR)/fs-worker" \
	  "$(LIB_DIR)/fs-worker" || \
	true; \
	ln \
	  -s \
	  "$(NODE_DIR)/utils" \
	  "$(LIB_DIR)/utils" || \
	true

publish-npm:

	cd \
	  "build"; \
	npm \
	  publish

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  $(DOC_DIR)

install-man:

	$(_INSTALL_DIR) \
	  "$(MAN_DIR)/man1"
	rst2man \
	  "man/lib$(_PROJECT).1.rst" \
	  "$(MAN_DIR)/man1/lib$(_PROJECT).1"

.PHONY: build check install build-npm build-webpack install-doc install-examples install-man build-npm install-npm install-scripts shellcheck
