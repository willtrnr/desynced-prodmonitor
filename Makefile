SHELL := /bin/sh


ZIP := $(shell command -v 7z || command -v 7zz)
ZIPFLAGS =

LUAFMT := lua-format
LUAFMTFLAGS =

LUAPACK := luapack
LUAPACKFLAGS = -vv \
	-p $(srcdir)/?.lua \
	-p $(builddir)/?.lua \
	-p $(builddir)/?.bundle.lua \
	--preload=desynced=desynced.lua


name := prodmonitor

srcdir := src
resdirs := skin
builddir := build

packages := data ui


sources := $(shell find $(srcdir) -name '*.lua' 2>/dev/null)

resources := $(shell find $(resdirs) ! -type d 2>/dev/null)
resources += def.json LICENSE

objects := $(patsubst $(srcdir)/%,$(builddir)/%,$(sources))

bundles := $(addprefix $(builddir)/,$(addsuffix .bundle.lua,$(packages)))

ui_LUAPACKFLAGS := --preload=data.=modpack.lua

.PHONY: all clean dist format

all: dist

$(builddir)/%.bundle.lua: $(srcdir)/%/init.lua $(sources)
	@mkdir -p $(builddir)
	$(LUAPACK) $(LUAPACKFLAGS) $($*_LUAPACKFLAGS) -o $@ $<

$(name).zip: $(bundles) $(resources)
	@rm -f $@
	$(ZIP) a $(ZIPFLAGS) $@ -- $^

dist: $(name).zip

clean:
	rm -rf $(name).zip $(builddir)

format: $(sources)
	$(LUAFMT) $(LUAFMTFLAGS) -i -- $^
