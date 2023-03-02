BUILD_FILE := ./.build/release/uti-convert

.PHONY: install build clean uninstall

all: install

install: $(BUILD_FILE)
	@sudo cp $(BUILD_FILE) /usr/local/bin/

fish-script:
ifneq ($(wildcard $(BUILD_FILE)),)
	@uti-convert --generate-completion-script > ~/.config/fish/completions/uti-convert.fish
else ifneq ($(wildcard /usr/local/bin/uti-convert),)
	@uti-convert --generate-completion-script > ~/.config/fish/completions/uti-convert.fish
else
	@echo "Please build or install first" >&2
	exit 1
endif

$(BUILD_FILE): build

build:
	@swift build -c release

clean:
	@rm -rf ./.build

uninstall:
	@sudo rm /usr/local/bin/uti-convert
