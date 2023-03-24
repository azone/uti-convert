binname := "uti-convert"
build_dir := "./.build/release"
build_file := build_dir + "/" + binname

prefix := "/usr/local"
bindir := prefix + "/bin"

default: build install

install:
    @install -d bindir
    @install -s {{build_file}} {{bindir}}
    @echo "Installed {{binname}} to {{bindir}}"

build:
    @swift build -Xswiftc -Osize -c release

clean:
    @rm -rf .build

uninstall:
    @rm -f {{bindir}}/{{binname}}