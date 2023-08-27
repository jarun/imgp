<h1 align="center">imgp</h1>

<p align="center">
<a href="https://github.com/jarun/imgp/releases/latest"><img src="https://img.shields.io/github/release/jarun/imgp.svg?maxAge=600" alt="Latest release" /></a>
<a href="https://repology.org/project/imgp/versions"><img src="https://repology.org/badge/tiny-repos/imgp.svg" alt="Availability"></a>
<a href="https://pypi.org/project/imgp/"><img src="https://img.shields.io/pypi/v/imgp.svg?maxAge=600" alt="PyPI" /></a>
<a href="https://circleci.com/gh/jarun/workflows/imgp"><img src="https://img.shields.io/circleci/project/github/jarun/imgp.svg" alt="Build Status" /></a>
<a href="https://github.com/jarun/imgp/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-GPLv3-yellowgreen.svg?maxAge=2592000" alt="License" /></a>
</p>

<p align="center">
<a href="https://asciinema.org/a/88448"><img src="https://asciinema.org/a/88448.svg" alt="imgp_asciicast" width="600"/></a>
</p>

<p align="center"><i>Watch imgp resize a directory of images in lightning speed!</i></p>

`imgp` is a command line image resizer and rotator for JPEG and PNG images. It can resize (or thumbnail) and rotate thousands of images in a go, at lightning speed, while saving significantly on storage.

Powered by multiprocessing, SIMD parallelism (thanks to the Pillow-SIMD library), an intelligent adaptive algorithm, recursive operations, shell completion scripts, EXIF preservation (and more), `imgp` is a very flexible utility with well-documented easy to use options.

`imgp` intends to be a stronger replacement of the Nautilus Image Converter extension, not tied to any file manager and way faster. On desktop environments (like Xfce or LxQt) which do not integrate Nautilus, `imgp` will save your day. File manager [nnn](https://github.com/jarun/nnn) provides a script to batch resize images with `imgp`.

### Table of Contents

- [Features](#features)
  - [Adaptive mode](#adaptive-mode)
- [Performance](#performance)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [From a package manager](#from-a-package-manager)
  - [Release packages](#release-packages)
  - [From source](#from-source)
  - [Running standalone](#running-standalone)
- [Shell completion](#shell-completion)
- [Usage](#usage)
  - [cmdline options](#cmdline-options)
  - [Operational notes](#operational-notes)
- [Examples](#examples)
- [Developers](#developers)

### Features

- resize by percentage or resolution
- rotate clockwise by specified angle
- adaptive resize considering orientation
- brute force to a resolution
- optimize images to save more space
- limit processing by minimum image size
- convert PNG to JPEG
- erase exif metadata
- specify output JPEG image quality
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

`imgp` requires Python 3.8 or later.

To install PIL library on Ubuntu, run:

    $ sudo apt-get install python3-pil

or, using pip3:

    $ sudo pip3 install pillow

pillow can be replaced by [pillow-simd](https://github.com/uploadcare/pillow-simd) on [SIMD](https://en.wikipedia.org/wiki/SIMD) processors.

#### From a package manager

Install `imgp` from your package manager. If the version available is dated try an alternative installation method.

<details><summary>Packaging status (expand)</summary>
<p>
<br>
<a href="https://repology.org/project/imgp/versions"><img src="https://repology.org/badge/vertical-allrepos/imgp.svg" alt="Packaging status"></a>
</p>
Unlisted packagers:
<p>
<br>
● <a href="https://github.com/jarun/homebrew-imgp">Homebrew TAP</a> (<code>brew install jarun/imgp/imgp</code>)<br>
● <a href="https://pypi.org/project/imgp/">PyPI</a> (<code>pip3 install imgp</code>)<br>
● <a href="http://codex.sourcemage.org/test/graphics/imgp/">Source Mage</a> (<code>cast imgp</code>)<br>
</p>
</details>

#### Release packages

Packages for Arch Linux, CentOS, Debian, Fedora, openSUSE Leap and Ubuntu are available with the [latest stable release](https://github.com/jarun/imgp/releases/latest).

#### From source

If you have git installed, clone this repository. Otherwise download the [latest stable release](https://github.com/jarun/imgp/releases/latest) or [development version](https://github.com/jarun/imgp/archive/master.zip) (*risky*).

Install to default location (`/usr/local`):

    $ sudo make install

To remove, run:

    $ sudo make uninstall

`PREFIX` is supported, in case you want to install to a different location.

#### Running standalone

`imgp` is a standalone utility. From the containing directory, run:

    $ ./imgp

### Shell completion

Shell completion scripts for Bash, Fish and Zsh can be found in respective subdirectories of [auto-completion/](https://github.com/jarun/imgp/blob/master/auto-completion). Please refer to your shell's manual for installation instructions.

### Usage

#### cmdline options

```
usage: imgp [-h] [-x res] [-o deg] [-a] [-c] [-e] [-f] [-H] [-i] [-k] [-m] [-M res]
            [-n] [-N] [-O] [-P] [-q N] [-r] [-s byte] [-w] [-d] [PATH [PATH ...]]

Resize, rotate JPEG and PNG images.

positional arguments:
  PATH                  source file or dir [default: current dir]

optional arguments:
  -h, --help            show this help message and exit
  -x res, --res res     output resolution in HxV or percentage
  -o deg, --rotate deg  rotate clockwise by angle (in degrees)
  -a, --adapt           adapt to resolution by orientation [default: off]
  -c, --convert         convert PNG to JPG format [default: off]
  -e, --eraseexif       erase exif metadata [default: off]
  -f, --force           force to exact specified resolution [default: off]
  -H, --hidden          include hidden (dot) files [default: off]
  -i, --includeimgp     re-process _IMGP files. * RISKY: refer to docs
  -k, --keep            skip (honors -c or --pr) images matching specified
                        H or V or --res=100 [default: off]
  -m, --mute            operate silently [default: informative]
  -M res, --minres res  min resolution in HxV or percentage of --res to resize
  -n, --enlarge         enlarge smaller images [default: off]
  -N, --nearest         use nearest neighbour interpolation for PNG [default: antialias]
  -O, --optimize        optimize the output images [default: off]
  -P, --progressive     save JPEG images as progressive [default: off]
  -q N, --quality N     quality factor (N=1-95, JPEG only) [default: 75]
  -r, --recurse         process non-symbolic dirs recursively [default: off]
  -s byte, --size byte  minimum size to process an image [default: 1024]
  -w, --overwrite       overwrite source images [default: off]
  -d, --debug           enable debug logs [default: off]
```

#### Operational notes

- Multiple files and directories can be specified as source. If `PATH` is omitted, the current directory is processed.
- Output image names are appended with **_IMGP** if `--overwrite` option is not used. By default *_IMGP* files are not processed. Doing so may lead to potential race conditions when `--overwrite` option is used.
- PNG files with lower target hres/vres are not converted (even if `--convert` is used). Run `imgp --convert (*.png)` separately to convert those.
- Resize and rotate are lossy operations. For additional reductions in size try `--optimize` and `--eraseexif` options.
- Option `--optimize` is slower, the encoder makes an extra pass over the image in order to select optimal encoder settings.
- Progressive JPEG images are saved as progressive.

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

6. Process images greater than 50KiB only:

       $ imgp -wrackx 1366x1000 -s 51200

7. Generate a 64px adapative thumbnail of the last modified file in the current dir:

       #!/usr/bin/env sh

       thumb64 ()
       {
           pop=$(ls -1t | head -1)
           imgp -acx 64x64 "$pop"
       }

### Developers

1. Copyright © 2016-2023 [Arun Prakash Jana](https://github.com/jarun)
2. [Ananya Jana](https://github.com/ananyajana)
