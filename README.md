# uti-convert

Convert file extension or MIME type to UTI(Uniform Type Identifiers) and vice versa.

## Usage

```bash
USAGE: uti-convert [--full-info] [--from-type <from-type>] <tags> ...

ARGUMENTS:
  <tags>                  type list

OPTIONS:
  --full-info             Show full information
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

```bash
> uti-convert jpg  gif
# output
jpg -> public.jpeg
gif -> com.compuserve.gif, com.apple.private.auto-loop-gif

> uti-convert image/jpg image/gif
# output
image/jpg -> public.jpeg
image/gif -> com.compuserve.gif, com.apple.private.auto-loop-gif


> uti-convert --full-info jpg gif
# output
jpg:
----
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe

gif:
----
UTIs: com.compuserve.gif, com.apple.private.auto-loop-gif
MIME types: image/gif
File extensions: gif

> uti-convert --full-info image/jpg image/gif
# output
image/jpg:
----------
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe

image/gif:
----------
UTIs: com.compuserve.gif
MIME types: image/gif
File extensions: gif
```

### Convert file extension to UITs

```bash
> uti-convert -f extension jpg
# output
jpg -> public.jpeg


> uti-convert --full-info -f extension jpg
# output
jpg:
----
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe
```

### Convert file to UITs

```bash
> uti-convert -f file somefile.jpg
# output
somefile.jpg -> public.jpeg


> uti-convert --full-info -f file somefile.jpg
# output
somefile.jpg:
-------------
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe
```

### Show information for any UTIs

```bash
uti-convert -f uti public.jpeg public.png
#output
public.jpeg:
------------
UTIs: public.jpeg
MIME types: image/jpeg, image/jpg
File extensions: jpeg, jpg, jpe

public.png:
-----------
UTIs: public.png
MIME types: image/png
File extensions: png
```
