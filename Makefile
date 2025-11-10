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

PREFIX ?= /usr/local
_PROJECT=crash-js
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
  $(_PROJECT) \
  $(DOC_FILES) \
  COPYING \
  package.json

all: build-man build-npm

check: shellcheck

shellcheck:

	shellcheck \
	  -s \
	    "bash" \
	  $(SCRIPT_FILES)

install: install-scripts install-doc install-examples install-man

install-scripts:

	$(_INSTALL_EXE) \
	  "$(_PROJECT)/$(_PROJECT)" \
	  "$(LIB_DIR)/$(_PROJECT)"
	$(_INSTALL_EXE) \
	  "$(_PROJECT)/fs-utils" \
	  "$(LIB_DIR)/fs-utils"
	$(_INSTALL_EXE) \
	  "$(_PROJECT)/utils" \
	  "$(LIB_DIR)/utils"
	$(_INSTALL_EXE) \
	  "$(_PROJECT)/fs-worker" \
	  "$(LIB_DIR)/fs-worker"

build-man:

	mkdir \
	  -p \
	  "build/man"
	rst2man \
	  "man/lib$(_PROJECT).1.rst" \
	  "build/man/lib$(_PROJECT).1"

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
	      "$$(pwd)" \
	      "version")"; \
	cp \
	  -r \
	  "$(_PROJECT)" \
	  "README.md" \
	  "COPYING" \
	  "AUTHORS.rst" \
	  "package.json" \
	  "build"; \
	cd \
	  "build"; \
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
	      "$$(pwd)" \
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

.PHONY: check install install-doc install-examples install-man build-npm install-npm install-scripts shellcheck
