SHELL := /bin/sh


ZIP := $(shell command -v 7z || command -v 7zz)
ZIPFLAGS :=

LUA := $(shell command -v lua5.4 || command -v lua)
LUAFLAGS :=

LUAROCKS := luarocks
LUAROCKSFLAGS :=

STYLUA := stylua
STYLUAFLAGS := --syntax=Lua54

LUAPACK := luapack
LUAPACKFLAGS := -vv


name := prodmonitor

srcdir := src
testdir := test
resdirs := skin
builddir := build

packages := data ui

ui_LUAPACKFLAGS = --preload=data=$(srcdir)/modpack.lua


sources := $(shell find $(srcdir) -name '*.lua' 2>/dev/null)

resources := $(shell find $(resdirs) ! -type d 2>/dev/null)
resources += def.json LICENSE

objects := $(patsubst $(srcdir)/%,$(builddir)/%,$(sources))
bundles := $(addprefix $(builddir)/,$(addsuffix .bundle.lua,$(packages)))


export LUA_PATH := $(srcdir)/?.lua;$(srcdir)/?/init.lua;$(builddir)/?.bundle.lua;$(shell $(LUAROCKS) path --lr-path || echo ';')
export LUA_CPATH := $(shell $(LUAROCKS) path --lr-cpath || echo ';;')


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
	$(STYLUA) $(STYLUAFLAGS) -- $^
