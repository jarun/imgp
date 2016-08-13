# imgd

`imgd` (read *imaged*) is a command line image-resizer (and more) written using the Python PIL library. If you have tons of images you would like to resize adaptively to a screen-size using a single command, `imgd` is the utility for you. In most cases, `imgd` will save on storage while converting to smaller resolutions. There are additional optimization options too.

`imgd` intends to be a stronger replacement for the resizer in Nautilus Image Converter extension, not tied to any File Manager and much faster. The Nautilus Image Converter is essentially a GTK extension with a library of its own that calls the `convert` utility of the ImageMagick library. On Desktop Environments (like Xfce or LxQt) which do not integrate Nautilus, `imgd` will save your day.

`imgd` works with Python 3.5 and above.

Nascent and under active development. Consider alpha.

[![Donate Button](https://img.shields.io/badge/paypal-donate-orange.svg?maxAge=2592000)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RMLTQ76JSXJ4Q)

# Features

- resize by percentage or resolution
- brute force to a resolution
- optimize images to save more space
- optionally convert PNG to JPEG
- option to erase exif metadata
- force only larger to smaller resize
- option to operate recusively
- overwrite source image option
- minimal dependencies

# Usage

## cmdline options

    usage: imgd [OPTIONS] [PATH [PATH ...]]

    Adapt images to a resolution.

    positional arguments:
      PATH               source file or directory

    optional arguments:
      -h, --help         show this help message and exit
      -s %, --scale %    scale image to percentage
      -x HxV, --res HxV  output resolution in HxV format
      -b, --brute        force to output resolution
      -c, --convert      convert PNG to JPG format
      -d, --dot          include hidden files
      -e, --eraseexif    erase exif metadata
      -n, --nolarge      do not enlarge smaller images
      -p, --optimize     optimize the output images
      -r, --recursive    process directories recursively
      -w, --overwrite    overwrite source images
      -z, --debug        enable debug logs

# License

GPLv3

# Developers

Copyright (C) 2016 [Arun Prakash Jana](mailto:engineerarun@gmail.com)
