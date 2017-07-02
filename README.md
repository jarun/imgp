<h1 align="center">imgp</h1>

<p align="center">
<a href="https://github.com/jarun/imgp/releases/latest"><img src="https://img.shields.io/github/release/jarun/imgp.svg?maxAge=600" alt="Latest release" /></a>
<a href="https://aur.archlinux.org/packages/imgp"><img src="https://img.shields.io/aur/version/imgp.svg?maxAge=600" alt="AUR" /></a>
<a href="https://packages.debian.org/search?keywords=imgp&searchon=names&exact=1"><img src="https://img.shields.io/badge/debian-9+-blue.svg?maxAge=2592000" alt="Debian Strech+" /></a>
<a href="http://packages.ubuntu.com/search?keywords=imgp&searchon=names&exact=1"><img src="https://img.shields.io/badge/ubuntu-17.04+-blue.svg?maxAge=2592000" alt="Ubuntu Zesty+" /></a>
<a href="https://github.com/jarun/imgp/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-GPLv3-yellow.svg?maxAge=2592000" alt="License" /></a>
</p>

<p align="center">
<a href="https://asciinema.org/a/e5qa0mipgg23v70hdn6i99b8q"><img src="https://asciinema.org/a/e5qa0mipgg23v70hdn6i99b8q.png" alt="imgp_asciicast" width="734"/></a>
</p>

`imgp` is a command line image resizer and rotator for JPEG and PNG images. If you have tons of images you want to resize adaptively to a screen resolution or rotate by an angle using a single command, `imgp` is the utility for you. It can save a lot on storage too.

Powered by multiprocessing, an intelligent adaptive algorithm, recursive operations, shell completion scripts, EXIF preservation (and more), `imgp` is a very flexible utility with well-documented easy to use options.

`imgp` intends to be a stronger replacement of the Nautilus Image Converter extension, not tied to any file manager and way faster. On desktop environments (like Xfce or LxQt) which do not integrate Nautilus, `imgp` will save your day.

<p align="center">
<a href="https://saythanks.io/to/jarun"><img src="https://img.shields.io/badge/say-thanks!-ff69b4.svg" /></a>
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RMLTQ76JSXJ4Q"><img src="https://img.shields.io/badge/PayPal-donate-FC746D.svg" alt="Donate via PayPal!" /></a>
</p>

### Table of Contents

- [Features](#features)
  - [Adaptive mode](#adaptive-mode)
- [Performance](#performance)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Installing with a package manager](#installing-with-a-package-manager)
  - [Installing from this repository](#installing-from-this-repository)
    - [Running as a standalone utility](#running-as-a-standalone-utility)
    - [Debian package](#debian-package)
- [Shell completion](#shell-completion)
- [Usage](#usage)
  - [cmdline options](#cmdline-options)
  - [Operational notes](#operational-notes)
- [Examples](#examples)
- [Copyright](#copyright)

### Features

- resize by percentage or resolution
- rotate clockwise by specified angle
- adaptive resize considering orientation
- brute force to a resolution
- optimize images to save more space
- limit processing by minimum image size
- convert PNG to JPEG
- erase exif metadata
- force smaller to larger resize
- process directories recursively
- overwrite source image option
- completion scripts for bash, fish, zsh
- minimal dependencies

#### Adaptive mode

- If the specified and image orientations are same [(H >= V and h > v) or (H < V and h < v)], the image is resized with the longer specified side as reference.
- In case of cross orientation [(H >= V and h <= v) or (H < V and h >= v)], the image is resized with the shorter specified side as reference. Same as non-adaptive.

For example, if an image has a resolution of 2048x1365 and is being resized to 1366x768:

- In regular mode (default), output image resolution will be 1152x768
- In adaptive mode, output image resolution will be 1366x910

### Performance

`imgp` could resize 8823 images (approx. 4.5GB in size) of mixed resolutions (high to regular) stored in a USB 2.0 external hard disk at an adaptive resolution of 1366x1000 in around 8 minutes. The resulting size was 897MB (approx. 20%).

`imgp` uses Python PIL/Pillow library. Nautilus Image Converter calls the `convert` utility from ImageMagick. For a comparative benchmark, head [here](https://github.com/uploadcare/pillow-simd#benchmarks).

### Installation

#### Dependencies

`imgp` requires Python 3.5 or later.

To install PIL library on Ubuntu, run:

    $ sudo apt-get install python3-pil

or, using pip3:

    $ sudo pip3 install pillow

pillow can be replaced by [pillow-simd](https://github.com/uploadcare/pillow-simd) on [SIMD](https://en.wikipedia.org/wiki/SIMD) processors.

#### Installing with a package manager

- [AUR](https://aur.archlinux.org/packages/imgp/)
- [Debian](https://packages.debian.org/search?keywords=imgp&searchon=names&exact=1)
- [Ubuntu](http://packages.ubuntu.com/search?keywords=imgp&searchon=names&exact=1)
- [Ubuntu PPA](https://launchpad.net/~twodopeshaggy/+archive/ubuntu/jarun/)
- [Homebrew *tap*](https://github.com/jarun/homebrew-imgp) [`brew install jarun/imgp/imgp`]

#### Installing from this repository

If you have git installed, clone this repository. Otherwise download the latest [stable release](https://github.com/jarun/imgp/releases/latest) or [development version](https://github.com/jarun/imgp/archive/master.zip) (*risky*).

Install to default location (`/usr/local`):

    $ sudo make install

To remove, run:

    $ sudo make uninstall
`PREFIX` is supported. You may need to use `sudo` with `PREFIX` depending on your permissions on destination directory.

##### Running as a standalone utility

`imgp` is a standalone utility. From the containing directory, run:

    $ ./imgp

##### Debian package

If you are on a Debian based system (including Ubuntu), visit [the latest stable release](https://github.com/jarun/imgp/releases/latest) and download the `.deb` package. To install, run

    $ sudo dpkg -i imgp-$version-all.deb
Please substitute `$version` with the appropriate package version.

### Shell completion

Shell completion scripts for Bash, Fish and Zsh can be found in respective subdirectories of [auto-completion/](https://github.com/jarun/imgp/blob/master/auto-completion). Please refer to your shell's manual for installation instructions.

### Usage

#### cmdline options

    usage: imgp [OPTIONS] [PATH [PATH ...]]

    Resize, rotate JPEG and PNG images.

    positional arguments:
      PATH                  source file or dir [default: current dir]

    optional arguments:
      -h, --help            show this help message and exit
      -x res, --res res     output resolution in HxV or percentage
      -o deg, --rotate deg  rotate clockwise by angle (in degrees)
      -q N, --quality N     save the image with a specified quality factor N(on
                            a scale of [1, 95]) [default: 75]
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
      -m, --mute            operate silently [default: verbose]
      -r, --recursive       process directories recursively [default: off]
                            symbolic links are ignored
      -s byte, --size byte  minimum size to process an image [default: 1024]
      -w, --overwrite       overwrite source images [default: off]
      -z, --debug           enable debug logs [default: off]

#### Operational notes

- Multiple files and directories can be specified as source. If `PATH` is omitted, the current directory is processed.
- Output image names are appended with **_IMGP** if `--overwrite` option is not used. By default *_IMGP* files are not processed. Doing so may lead to potential race conditions when `--overwrite` option is used.
- PNG files with lower target hres/vres are not converted (even if `--convert` is used). Run `imgp --convert` to convert those.
- Resize and rotate are lossy operations. For additional reductions in size try `--optimize` and `--eraseexif` options.
- Option `--optimize` is slower, the encoder makes an extra pass over the image in order to select optimal encoder settings.

### Examples

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

6. Process images greater than 50KB (50*1024 bytes) only:

        $ imgp -wrackx 1366x1000 -s 51200

### Copyright

Copyright © 2016-2017 [Arun Prakash Jana](https://github.com/jarun)
