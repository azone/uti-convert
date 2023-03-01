BUILD_FILE := ./.build/release/uti-convert

.PHONY: install build clean uninstall

all: install

install: $(BUILD_FILE)
	@sudo cp $(BUILD_FILE) /usr/local/bin/

$(BUILD_FILE): build

build:
	@swift build -c release

clean:
	@rm -rf ./.build

uninstall:
	@sudo rm /usr/local/bin/uti-convert