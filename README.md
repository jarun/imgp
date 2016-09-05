# imgd

`imgd` (pronounced *imaged*) is a multiprocessing command line image resizer and rotator for JPEG and PNG images. If you have tons of images you would like to resize adaptively to a screen-size or rotate by an angle using a single command, `imgd` is the utility for you.

Resize and rotation are lossy operations. In most cases, `imgd` will save on storage while converting to smaller resolutions. There are additional optimization options too. Output image names are appended with **_IMGD** if overwrite option is not used. By default *_IMGD* files are not processed. Doing so may lead to potential race conditions when overwrite option is used.

`imgd` intends to be a stronger replacement for the Nautilus Image Converter extension, not tied to any File Manager and much faster. The Nautilus Image Converter is essentially a GTK extension with a library of its own that calls the `convert` utility of the ImageMagick library. On desktop environments (like Xfce or LxQt) which do not integrate Nautilus, `imgd` will save your day.

Performance: imgd could resize 8823 images (~4.5GB in size) of mixed resolutions (high to regular) stored in an external USB 2.0 hard disk at an adaptive resolution of 1366x1000 in around 8 minutes. The resulting size was 897MB (~ 20%).

[![Donate Button](https://img.shields.io/badge/paypal-donate-orange.svg?maxAge=2592000)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RMLTQ76JSXJ4Q)

## Table of Contents

- [Features](#features)
  - [Adaptive mode](#adaptive-mode)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Installing from this repository](#installing-from-this-repository)
  - [Running as a standalone utility](#running-as-a-standalone-utility)
  - [Debian package](#debian-package)
  - [Arch users](#arch-users)
- [Usage](#usage)
  - [cmdline options](#cmdline-options)
- [Examples](#examples)
- [License](#license)
- [Developers](#developers)

## Features

- resize by percentage or resolution
- rotate clockwise by specified angle
- adaptive resize considering orientation
- brute force to a resolution
- optimize images to save more space
- convert PNG to JPEG
- erase exif metadata
- force smaller to larger resize
- process directories recursively
- overwrite source image option
- minimal dependencies

### Adaptive mode

- If the specified and image orientations are same [(H >= V and h > v) or (H < V and h < v)], the image is resized with the longer specified side as reference.
- In case of cross orientation [(H >= V and h <= v) or (H < V and h >= v)], the image is resized with the shorter specified side as reference. Same as non-adaptive.

For example, if an image has a resolution of 2048x1365 and is being resized to 1366x768:

- In regular mode (default), output image resolution will be 1152x768
- In adaptive mode, output image resolution will be 1366x910

## Installation

### Dependencies

`imgd` requires Python 3.5 or later. It uses the Python PIL/Pillow library.

To install PIL library on Ubuntu, run:

    $ sudo apt-get install python3-pil

or, using pip3:

    $ sudo pip3 install pillow

### Installing from this repository

If you have git installed, run:

    $ git clone https://github.com/jarun/imgd/
or download the latest [stable release](https://github.com/jarun/imgd/releases/latest) or [development version](https://github.com/jarun/imgd/archive/master.zip).

Install to default location (`/usr/local`):

    $ sudo make install

To remove, run:

    $ sudo make uninstall
`PREFIX` is supported. You may need to use `sudo` with `PREFIX` depending on your permissions on destination directory.

### Running as a standalone utility

`imgd` is a standalone utility. From the containing directory, run:

    $ ./imgd

### Debian package

If you are on a Debian based system (including Ubuntu), visit [the latest stable release](https://github.com/jarun/imgd/releases/latest) and download the.deb package. To install, run

    $ sudo dpkg -i imgd-$version-all.deb
Please substitute `$version` with the appropriate package version.

### Arch users

If you are on an Arch based system you can use the following AUR packages:

* **Official Releases**: https://aur.archlinux.org/packages/imgd/
* **Development Releases**: https://aur.archlinux.org/packages/imgd-git/

**Note**: If you're having trouble with the AUR packages please email the package maintainer at zach@zach-adams.com before creating an issue.

## Usage

### cmdline options

    usage: imgd [OPTIONS] PATH [PATH ...]

    Resize or rotate JPEG and PNG images.

    positional arguments:
      PATH               source file or directory

    optional arguments:
      -h, --help            show this help message and exit
      -s %, --scale %       scale image by percentage
      -x HxV, --res HxV     output resolution in HxV representation
      -o deg, --rotate deg  rotate clockwise by specified angle
      -a, --adapt           adapt to resolution by orientation [default: off]
      -c, --convert         convert PNG to JPG format [default: off]
      -d, --dot             include hidden files (on Linux) [default: off]
      -e, --eraseexif       erase exif metadata [default: off]
      -f, --force           force to exact specified resolution [default: off]
      -i, --processimgd     re-process generated files. * RISKY: refer to docs
      -k, --keep            skip (but convert, if opted) images with matching
                            specified hres or vres or scale=100 [default: off]
      -n, --enlarge         enlarge smaller images [default: off]
      -p, --optimize        optimize the output images [default: off]
      -q, --quiet           operate silently [default: verbose]
      -r, --recursive       process directories recursively [default: off]
      -w, --overwrite       overwrite source images [default: off]
      -z, --debug           enable debug logs [default: off]

## Examples

1. Convert some images and directories:

        $ imgd -x 1366x768 ~/ ~/Pictures/image3.png ~/Downloads/
        /home/testuser/image1.png
        3840x2160 -> 1365x768
        11104999 bytes -> 1486426 bytes

        /home/testuser/image2.jpg
        2048x1365 -> 1152x768
        224642 bytes -> 31421 bytes

        /home/testuser/Pictures/image3.png
        1920x1080 -> 1365x768
        2811155 bytes -> 1657474 bytes

        /home/testuser/Downloads/image4
        2048x1365 -> 1152x768
        224642 bytes -> 31421 bytes

2. Scale an image by 75% and overwrite the source image:

        $ imgd -s 75 -w ~/image.jpg
        /home/testuser/image.jpg
        1366x767 -> 1025x575
        120968 bytes -> 45040 bytes

3. Rotate an image clockwise by 90 degrees:

        $ imgd -o 90  ~/image.jpg
        120968 bytes -> 72038 bytes

4. Adapt the images in the current directory to 1366x1000 resolution. Visit all directories recursively, overwrite source images, ignore images with matching hres or vres but convert PNG images to JPEG.

        $ imgd -x 1366x1000 -wrack .

## License

GPLv3

## Developers

Copyright (C) 2016 [Arun Prakash Jana](mailto:engineerarun@gmail.com)
