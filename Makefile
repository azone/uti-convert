BUILD_FILE := ./.build/release/uti-convert

prefix ?= /usr/local
bindir ?= $(prefix)/bin

.PHONY: install build clean uninstall

all: install

install: $(BUILD_FILE)
	@install -d $(bindir)
	@install -s $< $(bindir)

fish-script:
ifneq ($(wildcard $(BUILD_FILE)),)
	@$(BUILD_FILE) --generate-completion-script fish > ~/.config/fish/completions/uti-convert.fish
else ifneq ($(wildcard $(bindir)/uti-convert),)
	@uti-convert --generate-completion-script fish > ~/.config/fish/completions/uti-convert.fish
else
	$(error "Please build or install first")
endif

$(BUILD_FILE): build

build:
	@swift build -Xswiftc -Osize -c release

clean:
	@rm -rf ./.build

uninstall:
	@sudo rm $(bindir)/uti-convert
