default: build

PACKAGES := node_modules/.build
BUILD := .build

MODS := $(CURDIR)/node_modules
NPATH := $(MODS)/.bin
TOOLPATH := $(CURDIR)/tools/bin
PAGES_SRC := $(shell find pages type f 2>/dev/null)

$(PACKAGES): package.json
	npm install
	touch $@ || type nul > $@

$(BUILD): $(PAGES_SRC) $(PACKAGES) sass webdeps Makefile .git/index
	touch $@ || type nul > $@

build: $(BUILD)

run: $(BUILD)
	npm start

run-debug: $(BUILD)
	npm run start-debug

run-debug-brk: $(BUILD)
	npm run start-debug-brk

lint:
	$(NPATH)/eslint src
	$(NPATH)/eslint --ext .mjs --config .eslintrc.modules.json src shared pages/src

unpacked: $(BUILD)
	SKIP_NOTARIZE=1 npm run unpacked

packed: $(BUILD)
	SKIP_NOTARIZE=1 npm run build

publish: $(BUILD)
	npm run publish

webdeps:
	cp node_modules/billboard.js/dist/billboard.pkgd.min.js pages/deps/src/billboard.js
	cp node_modules/billboard.js/dist/billboard.css pages/deps/css/
	cp node_modules/billboard.js/dist/theme/* pages/deps/css/

sass:
	$(NPATH)/sass pages/scss:pages/css

sass-watch:
	$(NPATH)/sass pages/scss:pages/css --watch

lint-watch:
	while true ; do \
		$(MAKE) lint; \
		sleep 5; \
	done

clean:
	rm -rf pages/deps/src/*
	rm -rf pages/deps/css/*
	rm $(BUILD)

.PHONY: build pack publish lint sass webdeps clean
