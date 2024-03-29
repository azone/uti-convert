# uti-convert

Convert file extension or MIME type to UTI(Uniform Type Identifiers) and vice versa.

## Installation

1. Clone or download the source code from this repository
2. cd the source code directory
3. do `make install` command

## Generate shell completion script

### For fish

```
uti-convert --generate-completion-script > ~/.config/fish/completions/uti-convert.fish
```

### For zsh

```
uti-convert --generate-completion-script > ~/.oh-my-zsh/completions/_uti-convert # or other completion script file/directory
```

### For bash

```
uti-convert --generate-completion-script >> ~/.bashrc # or other completion script file/directory
```

> **Note:** _This command will detect current shell automatically, or you can specify one with: `uti-convert --generate-completion-script [fish|zsh|bash] > /path/to/completion/file`_

## Usage

```
uti-convert [--full] [--from-type <from-type>] <tags> ...

ARGUMENTS:
  <tags>                  type list

OPTIONS:
  --full                  Show full information
  --without-tree          Without UTI tree information
  -f, --from-type <from-type>
                          Which type should convert, the available types are:
                              - file: get file extension automatically from file
                              - extension: file extension, e.g. swift
                              - mime: MIME type, e.g. png
                              - uti: show MIME types and file extensions for specified UTI
                              - auto: detect extension or mime type automatically (default: auto)
  -h, --help              Show help information.

```

### Show UTIs with auto-detection

```
> uti-convert jpg  gif
# output
jpg -> public.jpeg
gif -> com.compuserve.gif, com.apple.private.auto-loop-gif

> uti-convert image/jpg image/gif
# output
image/jpg -> public.jpeg
image/gif -> com.compuserve.gif, com.apple.private.auto-loop-gif


> uti-convert --full jpg gif
# output
jpg:
----
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe
UTI Tree:
╭────────╯
╰── public.jpeg
   ├── public.content
   ├── public.data
   │  ╰── public.item
   ├── public.image
   │  ├── public.content
   │  ├── public.data
   │  │  ╰── public.item
   │  ╰── public.item
   ╰── public.item

gif:
----
UTIs: com.compuserve.gif, com.apple.private.auto-loop-gif
MIME types: image/gif
File extensions: gif
UTI Tree:
╭────────╯
├── com.compuserve.gif
│  ├── public.content
│  ├── public.data
│  │  ╰── public.item
│  ├── public.image
│  │  ├── public.content
│  │  ├── public.data
│  │  │  ╰── public.item
│  │  ╰── public.item
│  ╰── public.item
╰── com.apple.private.auto-loop-gif

> uti-convert --full image/jpg image/gif
# output
jpg:
----
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe
UTI Tree:
╭────────╯
╰── public.jpeg
   ├── public.content
   ├── public.data
   │  ╰── public.item
   ├── public.image
   │  ├── public.content
   │  ├── public.data
   │  │  ╰── public.item
   │  ╰── public.item
   ╰── public.item

gif:
----
UTIs: com.compuserve.gif, com.apple.private.auto-loop-gif
MIME types: image/gif
File extensions: gif
UTI Tree:
╭────────╯
├── com.compuserve.gif
│  ├── public.content
│  ├── public.data
│  │  ╰── public.item
│  ├── public.image
│  │  ├── public.content
│  │  ├── public.data
│  │  │  ╰── public.item
│  │  ╰── public.item
│  ╰── public.item
╰── com.apple.private.auto-loop-gif
```

### Convert file extension to UITs

```
> uti-convert -f extension jpg
# output
jpg -> public.jpeg


> uti-convert --full -f extension jpg
# output
jpg:
----
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe
UTI Tree:
╭────────╯
╰── public.jpeg
   ├── public.content
   ├── public.data
   │  ╰── public.item
   ├── public.image
   │  ├── public.content
   │  ├── public.data
   │  │  ╰── public.item
   │  ╰── public.item
   ╰── public.item
```

### Convert file to UITs

```
> uti-convert -f file somefile.jpg
# output
somefile.jpg -> public.jpeg


> uti-convert --full -f file somefile.jpg
# output
somefile.jpg:
-------------
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe
UTI Tree:
╭────────╯
╰── public.jpeg
   ├── public.content
   ├── public.data
   │  ╰── public.item
   ├── public.image
   │  ├── public.content
   │  ├── public.data
   │  │  ╰── public.item
   │  ╰── public.item
   ╰── public.item
```

### Show information for any UTIs

```
> uti-convert -f uti public.jpeg public.png
# output
public.jpeg:
------------
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe
UTI Tree:
╭────────╯
╰── public.jpeg
   ├── public.content
   ├── public.data
   │  ╰── public.item
   ├── public.image
   │  ├── public.content
   │  ├── public.data
   │  │  ╰── public.item
   │  ╰── public.item
   ╰── public.item

public.png:
-----------
UTIs: public.png
MIME types: image/png
File extensions: png
UTI Tree:
╭────────╯
╰── public.png
   ├── public.content
   ├── public.data
   │  ╰── public.item
   ├── public.image
   │  ├── public.content
   │  ├── public.data
   │  │  ╰── public.item
   │  ╰── public.item
   ╰── public.item
```
