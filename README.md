# imgd

`imgd` (read *imaged*) is a command line image-resizer (and more) written using the Python PIL library. If you have tons of images you would like to resize adaptively to a screen-size using a single command, `imgd` is the utility for you. In most cases, `imgd` will save on storage while converting to smaller resolutions. There are additional optimization options too. Output image names are appended with **_IMGD** if overwrite option is not used.

`imgd` intends to be a stronger replacement for the resizer in Nautilus Image Converter extension, not tied to any File Manager and much faster. The Nautilus Image Converter is essentially a GTK extension with a library of its own that calls the `convert` utility of the ImageMagick library. On Desktop Environments (like Xfce or LxQt) which do not integrate Nautilus, `imgd` will save your day.

`imgd` works with Python 3.5 and above.

[![Donate Button](https://img.shields.io/badge/paypal-donate-orange.svg?maxAge=2592000)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RMLTQ76JSXJ4Q)

# Features

- resize by percentage or resolution
- adaptive resize considering orientation
- brute force to a resolution
- optimize images to save more space
- convert PNG to JPEG
- erase exif metadata
- force only larger to smaller resize
- process directories recursively
- overwrite source image option
- minimal dependencies

## Adaptive mode

- If the specified and image orientations are same [(H > V and h > v) or (H < V and h < v)], the image is resized with the longer side as reference.
- In case of cross orientation [(H > V and h < v) or (H < V and h > v)], the image is resized with the shorter side as reference. Same as non-adaptive.

For example, if an image has a resolution of 2048x1365 and is being resized to 1366x768:

- In regular mode, output image resolution will be 1152x768
- In adaptive mode, output image resolution will be 1366x910

# Usage

## cmdline options

    usage: imgd [OPTIONS] PATH [PATH ...]

    Adapt images to a resolution.

    positional arguments:
      PATH               source file or directory

    optional arguments:
      -h, --help         show this help message and exit
      -s %, --scale %    scale image by percentage
      -x HxV, --res HxV  output resolution in HxV representation
      -a, --adapt        adapt to resolution by orientation [default: off]
      -c, --convert      convert PNG to JPG format [default: off]
      -d, --dot          include hidden files (on Linux) [default: off]
      -e, --eraseexif    erase exif metadata [default: off]
      -f, --force        force to exact pecified resolution [default: off]
      -k, -keep          best fit to resolution [default: off]
      -n, --nolarge      do not enlarge smaller images [default: scale up]
      -p, --optimize     optimize the output images [default: off]
      -q, --quiet        operate silently [default: verbose]
      -r, --recursive    process directories recursively [default: off]
      -w, --overwrite    overwrite source images [default: off]
      -z, --debug        enable debug logs [default: off]

# Examples

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

# License

GPLv3

# Developers

Copyright (C) 2016 [Arun Prakash Jana](mailto:engineerarun@gmail.com)
