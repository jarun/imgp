<h1 align="center">imgp</h1>

<p align="center">
<a href="https://github.com/jarun/imgp/releases/latest"><img src="https://img.shields.io/github/release/jarun/imgp.svg" alt="Latest release" /></a>
<a href="https://aur.archlinux.org/packages/imgp"><img src="https://img.shields.io/aur/version/imgp.svg" alt="AUR" /></a>
<a href="https://github.com/jarun/imgp/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-GPLv3-yellow.svg?maxAge=2592000" alt="License" /></a>
</p>

`imgp` is a command line image resizer and rotator for JPEG and PNG images. If you have tons of images you would like to resize adaptively to a screen-size or rotate by an angle using a single command, `imgp` is the utility for you.

It comes with an intelligent adaptive algorithm, recursive operations, multiprocessing, shell completion scripts, EXIF preservation and more.

`imgp` intends to be a stronger replacement for the Nautilus Image Converter extension, not tied to any file manager and way faster. On desktop environments (like Xfce or LxQt) which do not integrate Nautilus, `imgp` will save your day.

<p align="center">
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RMLTQ76JSXJ4Q"><img src="https://img.shields.io/badge/paypal-donate-orange.svg?maxAge=2592000" alt="Donate" /></a>
</p>

## Table of Contents

- [Features](#features)
  - [Adaptive mode](#adaptive-mode)
- [Performance](#performance)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Installing from this repository](#installing-from-this-repository)
  - [Running as a standalone utility](#running-as-a-standalone-utility)
  - [Debian package](#debian-package)
  - [Arch users](#arch-users)
- [Shell completion](#shell-completion)
- [Usage](#usage)
  - [cmdline options](#cmdline-options)
  - [Operational notes](#operational-notes)
- [Examples](#examples)
- [Copyright](#copyright)

## FEATURES

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
- completion scripts for bash, fish, zsh
- minimal dependencies

### Adaptive mode

- If the specified and image orientations are same [(H >= V and h > v) or (H < V and h < v)], the image is resized with the longer specified side as reference.
- In case of cross orientation [(H >= V and h <= v) or (H < V and h >= v)], the image is resized with the shorter specified side as reference. Same as non-adaptive.

For example, if an image has a resolution of 2048x1365 and is being resized to 1366x768:

- In regular mode (default), output image resolution will be 1152x768
- In adaptive mode, output image resolution will be 1366x910

## PERFORMANCE

`imgp` could resize 8823 images (~4.5GB in size) of mixed resolutions (high to regular) stored in an external USB 2.0 hard disk at an adaptive resolution of 1366x1000 in around 8 minutes. The resulting size was 897MB (~ 20%).

`imgp` uses Python PIL/Pillow library. Nautilus Image Converter calls the `convert` utility from ImageMagick. For a comparative benchmark, head [here](https://github.com/uploadcare/pillow-simd#benchmarks).

## INSTALLATION

### Dependencies

`imgp` requires Python 3.5 or later.

To install PIL library on Ubuntu, run:

    $ sudo apt-get install python3-pil

or, using pip3:

    $ sudo pip3 install pillow

To utilize the full power of modern CPUs with [SIMD](https://en.wikipedia.org/wiki/SIMD) support, replace pillow with [pillow-simd](https://github.com/uploadcare/pillow-simd).

### Installing from this repository

If you have git installed, run:

    $ git clone https://github.com/jarun/imgp/
or download the latest [stable release](https://github.com/jarun/imgp/releases/latest) or [development version](https://github.com/jarun/imgp/archive/master.zip).

Install to default location (`/usr/local`):

    $ sudo make install

To remove, run:

    $ sudo make uninstall
`PREFIX` is supported. You may need to use `sudo` with `PREFIX` depending on your permissions on destination directory.

### Running as a standalone utility

`imgp` is a standalone utility. From the containing directory, run:

    $ ./imgp

### Debian package

If you are on a Debian based system (including Ubuntu), visit [the latest stable release](https://github.com/jarun/imgp/releases/latest) and download the.deb package. To install, run

    $ sudo dpkg -i imgp-$version-all.deb
Please substitute `$version` with the appropriate package version.

### Arch users

If you are on an Arch based system you can use the following AUR packages:

* **Official Releases**: https://aur.archlinux.org/packages/imgp/
* **Development Releases**: https://aur.archlinux.org/packages/imgp-git/

**Note**: If you're having trouble with the AUR packages please email the package maintainer at zach@zach-adams.com before creating an issue.

## SHELL COMPLETION

Shell completion scripts for Bash, Fish and Zsh can be found in respective subdirectories of [auto-completion/](https://github.com/jarun/imgp/blob/master/auto-completion). Please refer to your shell's manual for installation instructions.

## USAGE

### cmdline options

    usage: imgp [OPTIONS] [PATH [PATH ...]]

    Resize, rotate JPEG and PNG images.

    positional arguments:
      PATH                  source file or dir [default: current dir]

    optional arguments:
      -h, --help            show this help message and exit
      -x res, --res res     output resolution in HxV or percentage
      -o deg, --rotate deg  rotate clockwise by angle (in degrees)
      -a, --adapt           adapt to resolution by orientation [default: off]
      -c, --convert         convert PNG to JPG format [default: off]
      -d, --dot             include hidden files (on Linux) [default: off]
      -e, --eraseexif       erase exif metadata [default: off]
      -f, --force           force to exact specified resolution [default: off]
      -i, --includeimgp     re-process _IMGP files. * RISKY: refer to docs
      -k, --keep            skip (but convert, if opted) images with matching
                            specified hres or vres or --res=100 [default: off]
      -n, --enlarge         enlarge smaller images [default: off]
      -p, --optimize        optimize the output images [default: off]
      -q, --quiet           operate silently [default: verbose]
      -r, --recursive       process directories recursively [default: off]
                            symbolic links to directories are ignored
      -w, --overwrite       overwrite source images [default: off]
      -z, --debug           enable debug logs [default: off]

### Operational notes

- Resize and rotate are lossy operations. For additional reductions in size try `--optimize` and `--eraseexif` options.
- Output image names are appended with **_IMGP** if overwrite option is not used. By default *_IMGP* files are not processed. Doing so may lead to potential race conditions when `--overwrite` option is used.

## EXAMPLES

1. Convert some images and directories:

        $ imgp -x 1366x768 ~/ ~/Pictures/image3.png ~/Downloads/
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

        $ imgp -x 75 -w ~/image.jpg
        /home/testuser/image.jpg
        1366x767 -> 1025x575
        120968 bytes -> 45040 bytes

3. Rotate an image clockwise by 90 degrees:

        $ imgp -o 90  ~/image.jpg
        120968 bytes -> 72038 bytes

4. Adapt the images in the current directory to 1366x1000 resolution. Visit all directories recursively, overwrite source images, ignore images with matching hres or vres but convert PNG images to JPEG.

        $ imgp -x 1366x1000 -wrack

5. Set hres=800 and adapt vres maintaining the ratio.

        $ imgp -x 800x0
        Source omitted. Processing current directory...

        ./image1.jpg
        1366x911 -> 800x534
        69022 bytes -> 35123 bytes

        ./image2.jpg
        1050x1400 -> 800x1067
        458092 bytes -> 78089 bytes

## COPYRIGHT

Copyright (C) 2016 [Arun Prakash Jana](mailto:engineerarun@gmail.com)
