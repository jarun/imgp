#!/usr/bin/env python3
#
# Resize or rotate JPEG and PNG images.
#
# Copyright © 2016-2023 Arun Prakash Jana <engineerarun@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import argparse
import textwrap
from multiprocessing import Pool, Lock
import os
import sys
import time
import PIL
from PIL import Image, ImageFile

if not hasattr(PIL.Image, 'Resampling'):  # Pillow<9.0
    PIL.Image.Resampling = PIL.Image

# Globals
HRES = 0  # specified horizontal resolution
VRES = 0  # specified vertical resolution
scale = None  # specified scale in percentage
rotate = None  # specified rotation in degree
adapt = False  # use adaptive resolution
convert = False  # convert PNG to JPG
hidden = False  # process hidden files
eraseexif = False  # erase EXIF metadata
progressive = False  # save as a progressive image
force = False  # forced to exact specified resolution
includeimgp = False  # process _IMGP files
keep = False  # ignore images with matching hres or vres
minH = 0  # min horizontal resolution to convert
minV = 0  # min vertical resolution to convert
enlarge = False  # enlarge images with smaller hres or vres
optimal = False  # apply PIL library optimization when saving
mute = False  # suppress additional information
recurse = False  # recursively process subdirectories
size = 1024  # min byte size to process an image
qual = 75  # the default value of quality factor
overwrite = False  # remove source images
debug = False  # enable debug information
no_res_opt = False  # --res is not specified
pad = '_IMGP'  # output file suffix when --overwrite is unused
png_ip = Image.Resampling.LANCZOS  # default interpolation for PNG
fill_color = '#ffffff'  # BG color to strip alpha channel
init_time = time.time()  # profile the total time taken
_VERSION_ = '2.9'  # current program version

# Globals for multiprocessing
pool = None
lock = Lock()
count = 0  # successful conversion count
count_lowres = 0  # no-op count due to low resolution


def getres(res):
    '''Retrieve hres and vres as a tuple

    :param res: resolution in hresxvres format
    '''

    hxv = res.split('x')
    if len(hxv) != 2:
        return (0, 0)

    try:
        return (int(hxv[0]), int(hxv[1]))
    except Exception:
        return (0, 0)


def lock_print(msg):
    '''Acquire lock and print a message'''

    global lock

    with lock:
        print(msg)


def cb(data):
    global count, count_lowres

    if data:
        count += data[0]
        count_lowres += data[1]


def traverse_dir(path):
    '''Traverse a directory recursively'''

    global lock, pool

    try:
        for entry in os.scandir(path):
            # Add check for hidden here
            if not hidden and entry.name.startswith('.'):
                continue

            if entry.is_dir(follow_symlinks=False):
                if recurse:
                    if not os.access(entry.path, os.W_OK | os.X_OK):
                        lock_print(entry.path + ': no permission')
                        continue
                    traverse_dir(entry.path)
            elif (entry.is_file(follow_symlinks=False) and
                  entry.stat().st_size >= size):
                if rotate is not None:
                    pool.apply_async(rotate_image, args=(entry.path,), callback=cb)
                else:
                    pool.apply_async(resize_image, args=(entry.path,), callback=cb)
    except OSError as e:
        with lock:
            print(e)


def rotate_image(src):
    '''Rotate a source image'''

    global lock

    converted = False
    _progressive = progressive
    name, ext = os.path.splitext(src)
    if name.endswith(pad) and not includeimgp:
        return

    try:
        img = Image.open(src)
        _format = img.format

        if _format not in ['JPEG', 'PNG', 'MPO']:
            if debug:
                lock_print(src + ': not JPEG/PNG/MPO. format: ' + _format)
            return

        try:
            if _format == 'JPEG' and not _progressive and img.info['progressive']:
                if debug:
                    lock_print('resize_image: progressive')
                _progressive = True
        except Exception:
            pass

        try:
            if eraseexif:
                exifdata = b''
            else:
                exifdata = img.info['exif']
        except Exception:
            exifdata = b''
    except OSError as e:
        if not str(e).startswith('cannot identify image file'):
            with lock:
                print(e)
        return

    # Image.rotate(angle, resample=0, expand=0) expand = True means
    # the image will be enlarged to hold the entire rotated image
    img = img.rotate(-rotate, 0, True)

    if not mute:
        stats = src + '\n%ld bytes ->' % os.path.getsize(src)

    if overwrite:
        suffix = ''
    else:
        suffix = pad

    if convert and _format == 'PNG':
        if img.mode in ('RGBA', 'LA'):
            background = Image.new(img.mode[:-1], img.size, fill_color)
            background.paste(img, img.split()[-1])
            img = background
        elif img.mode == "P":
            img.convert("RGBA")
        dest = name + suffix + '.jpg'
        _format = 'JPEG'
        converted = True
    else:
        dest = name + suffix + ext

    try:
        img.save(dest, _format, quality=qual, optimize=optimal, exif=exifdata, progressive=_progressive)

        if not mute:
            lock_print('%s %ld bytes\n' % (stats, os.path.getsize(dest)))

        if overwrite and converted:
            os.remove(src)

        return [1, 0]
    except OSError as e:
        with lock:
            print(e)


def resize_image(src):
    '''Resize a source image'''

    global HRES, VRES, minH, minV, lock

    converted = False
    _progressive = progressive
    name, ext = os.path.splitext(src)
    if name.endswith(pad) and not includeimgp:
        return

    try:
        img = Image.open(src)
        _format = img.format

        if _format not in ['JPEG', 'PNG', 'MPO']:
            if debug:
                lock_print(src + ': not JPEG/PNG/MPO. format: ' + _format)
            return

        # check if convert or progressive is specified without any resolution option
        if no_res_opt:
            if convert and _format != 'PNG':
                if debug:
                    lock_print('resize_image: cannot convert non-PNG')
                return

            if progressive and _format not in ['JPEG', 'MPO']:
                if debug:
                    lock_print('resize_image: cannot make non-JPEG/MPO progressive')
                return

        try:
            if _format == 'JPEG' and not _progressive and img.info['progressive']:
                if debug:
                    lock_print('resize_image: progressive')
                _progressive = True
        except Exception:
            pass

        try:
            if eraseexif:
                exifdata = b''
            else:
                exifdata = img.info['exif']
        except Exception:
            exifdata = b''
    except OSError as e:
        if not str(e).startswith('cannot identify image file'):
            with lock:
                print(e)
        return

    hres = img.size[0]
    vres = img.size[1]
    ImageFile.MAXBLOCK = hres * vres

    antialias = png_ip if _format == 'PNG' else Image.Resampling.LANCZOS

    if hres < minH or vres < minV:
        if debug:
            lock_print('resize_image: hres < minH or vres < minV')
        return

    if keep and (HRES == hres or VRES == vres or scale == 100):
        if progressive and _format not in ['JPEG', 'MPO']:
            return

        if convert and _format != 'PNG':
            return
    elif scale:
        if scale == 100:
            _hres = hres
            _vres = vres
        else:
            _hres = hres * scale/float(100)
            # use custom round()
            if _hres >= int(_hres) + .5:
                _hres = _hres + 1
            _hres = int(_hres)

            _vres = vres * scale/float(100)
            if _vres >= int(_vres) + .5:
                _vres = _vres + 1
            _vres = int(_vres)

        img = img.resize((_hres, _vres), antialias)
        if debug:
            lock_print('resize_image: scaled to [%dx%d]' % (_hres, _vres))
    elif HRES == 0 or VRES == 0:
        if HRES:
            if not enlarge and HRES > hres:
                if not mute:
                    lock_print('%s has lesser hres\n' % src)
                return [0, 1]

            hratio = HRES/float(hres)
            target_vres = vres * hratio
            if target_vres >= int(target_vres) + .5:
                target_vres = target_vres + 1
            target_vres = int(target_vres)

            img = img.resize((HRES, target_vres), antialias)
            if debug:
                lock_print('resize_image: 0 vres %dx%d' % (HRES, target_vres))

        if VRES:
            if not enlarge and VRES > vres:
                if not mute:
                    lock_print('%s has lesser vres\n' % src)
                return [0, 1]

            vratio = VRES/float(vres)
            target_hres = hres * vratio
            if target_hres >= int(target_hres) + .5:
                target_hres = target_hres + 1
            target_hres = int(target_hres)

            img = img.resize((target_hres, VRES), antialias)
            if debug:
                lock_print('resize_image: 0 hres %dx%d' % (target_hres, VRES))
    elif HRES == hres and VRES == vres:
        if debug:
            lock_print('resize_image: same res [%dx%d]' % (HRES, VRES))
    elif force:
        img = img.resize((HRES, VRES), antialias)
        if debug:
            lock_print('resize_image: brute force res to [%dx%d]' % (HRES, VRES))
    elif adapt:
        ratio_img = float(hres/vres)
        ratio_target = float(HRES/VRES)

        if (ratio_target >= 1 and ratio_img > 1) or (ratio_target < 1 and ratio_img >= 1):
            # same orientation (H >= V and h > v) or
            # cross orientation (H < V and h >= v)
            if not enlarge and HRES > hres:
                if not mute:
                    lock_print('%s has lesser hres\n' % src)
                return [0, 1]

            if HRES != hres:
                hratio = HRES/float(hres)
                target_vres = vres * hratio
                if target_vres >= int(target_vres) + .5:
                    target_vres = target_vres + 1
                target_vres = int(target_vres)

                img = img.resize((HRES, target_vres), antialias)
                if debug:
                    lock_print('resize_image: vres adapted %dx%d' % (HRES, target_vres))
        elif (ratio_target < 1 and ratio_img < 1) or (ratio_target >= 1 and ratio_img <= 1):
            # same orientation (H < V and h < v) or
            # cross orientation (H >= V and h <= v)
            if not enlarge and VRES > vres:
                if not mute:
                    lock_print('%s has lesser vres\n' % src)
                return [0, 1]

            if VRES != vres:
                vratio = VRES/float(vres)
                target_hres = hres * vratio
                if target_hres >= int(target_hres) + .5:
                    target_hres = target_hres + 1
                target_hres = int(target_hres)

                img = img.resize((target_hres, VRES), antialias)
                if debug:
                    lock_print('resize_image: hres adapted %dx%d' % (target_hres, VRES))
    else:
        ratio_img = float(hres/vres)
        ratio_target = float(HRES/VRES)

        if ratio_img >= ratio_target:
            if not enlarge and HRES > hres:
                if not mute:
                    lock_print('%s has lesser hres\n' % src)
                return [0, 1]

            # re-sample as per target horizontal resolution
            hratio = HRES/float(hres)
            target_vres = vres * hratio
            if target_vres >= int(target_vres) + .5:
                target_vres = target_vres + 1
            target_vres = int(target_vres)

            img = img.resize((HRES, target_vres), antialias)
            if debug:
                lock_print('resize_image: vres calculated %dx%d' % (HRES, target_vres))
        else:
            if not enlarge and VRES > vres:
                if not mute:
                    lock_print('%s has lesser vres\n' % src)
                return [0, 1]

            # re-sample as per target vertical resolution
            vratio = VRES/float(vres)
            target_hres = hres * vratio
            if target_hres >= int(target_hres) + .5:
                target_hres = target_hres + 1
            target_hres = int(target_hres)

            img = img.resize((target_hres, VRES), antialias)
            if debug:
                lock_print('resize_image: hres calculated %dx%d' % (target_hres, VRES))

    if not mute:
        stats = src + '\n%dx%d -> %dx%d\n%ld bytes ->' % (hres, vres, img.size[0], img.size[1], os.path.getsize(src))

    if overwrite:
        suffix = ''
    else:
        suffix = pad

    if convert and _format == 'PNG':
        if img.mode in ('RGBA', 'LA'):
            background = Image.new(img.mode[:-1], img.size, fill_color)
            background.paste(img, img.split()[-1])
            img = background
        elif img.mode == "P":
            img = img.convert("RGBA")
        dest = name + suffix + '.jpg'
        _format = 'JPEG'
        converted = True
    else:
        dest = name + suffix + ext

    try:
        img.save(dest, _format, quality=qual, optimize=optimal, exif=exifdata, progressive=_progressive)

        if not mute:
            lock_print('%s %ld bytes\n' % (stats, os.path.getsize(dest)))

        if overwrite and converted:
            os.remove(src)

        return [1, 0]
    except OSError as e:
        with lock:
            print(e)


class ExtendedArgumentParser(argparse.ArgumentParser):
    '''Extend classic argument parser'''

    # Print additional help and info
    @staticmethod
    def print_extended_help(file=None):
        if not file:
            file = sys.stderr

        file.write('''
Version %s
Copyright © 2016-2023 Arun Prakash Jana <engineerarun@gmail.com>
License: GPLv3
Webpage: https://github.com/jarun/imgp
''' % _VERSION_)

    # Help
    def print_help(self, file=None):
        super().print_help(file)
        self.print_extended_help(file)


def parse_args(args=None, namespace=None):
    '''Parse imgp arguments/options.
    Parameters
    ----------
    args : list, optional
        Arguments to parse. Default is ``sys.argv``.
    namespace : argparse.Namespace
        Namespace to write to. Default is a new namespace.
    Returns
    -------
    argparse.Namespace
        Namespace with parsed arguments / options.
    '''

    argparser = ExtendedArgumentParser(description='Resize, rotate JPEG and PNG images.',
                                       formatter_class=argparse.RawTextHelpFormatter)
    addarg = argparser.add_argument
    addarg('-x', '--res', nargs=1, metavar='res',
           help='output resolution in HxV or percentage')
    addarg('-o', '--rotate', type=int, metavar='deg',
           help='rotate clockwise by angle (in degrees)')
    addarg('-a', '--adapt', action='store_true',
           help='adapt to resolution by orientation [default: off]')
    addarg('-c', '--convert', action='store_true',
           help='convert PNG to JPG format [default: off]')
    addarg('-e', '--eraseexif', action='store_true',
           help='erase exif metadata [default: off]')
    addarg('-f', '--force', action='store_true',
           help='force to exact specified resolution [default: off]')
    addarg('-H', '--hidden', action='store_true',
           help='include hidden (dot) files [default: off]')
    addarg('-i', '--includeimgp', action='store_true',
           help='re-process _IMGP files. * RISKY: refer to docs')
    addarg('-k', '--keep', action='store_true',
           help=textwrap.dedent('''\
                skip (honors -c or --pr) images matching specified
                H or V or --res=100 [default: off]'''))
    addarg('-m', '--mute', action='store_true',
           help='operate silently [default: informative]')
    addarg('-M', '--minres', nargs=1, metavar='res',
           help='min resolution in HxV or percentage of --res to resize')
    addarg('-n', '--enlarge', action='store_true',
           help='enlarge smaller images [default: off]')
    addarg('-N', '--nearest', action='store_true',
           help='use nearest neighbour interpolation for PNG [default: antialias]')
    addarg('-O', '--optimize', action='store_true',
           help='optimize the output images [default: off]')
    addarg('-P', '--progressive', action='store_true',
           help='save JPEG images as progressive [default: off]')
    addarg('-q', '--quality', type=int, metavar='N', choices=range(1, 96),
           help='quality factor (N=1-95, JPEG only) [default: 75]')
    addarg('-r', '--recurse', action='store_true',
           help='process non-symbolic dirs recursively [default: off]')
    addarg('-s', '--size', type=int, metavar='byte',
           help='minimum size to process an image [default: 1024]')
    addarg('-w', '--overwrite', action='store_true',
           help='overwrite source images [default: off]')
    addarg('-d', '--debug', action='store_true',
           help='enable debug logs [default: off]')
    addarg('keywords', nargs='*', metavar='PATH',
           help='source file or dir [default: current dir]')

    # Show help and exit if no arguments
    if len(sys.argv) < 2:
        argparser.print_help(sys.stderr)
        sys.exit(1)

    return argparser.parse_args(args, namespace)


def main():
    global HRES, VRES, scale, rotate, adapt, convert, hidden, eraseexif, force, \
           includeimgp, keep, enlarge, optimal, progressive, mute, recurse, size, \
           qual, overwrite, debug, no_res_opt, pool, init_time, count, png_ip, minH, minV

    args = parse_args()

    if args.rotate is not None and args.res is not None:
        print('options --rotate and --res cannot be used together')
        return

    if args.res is not None:
        if 'x' in args.res[0]:
            HRES, VRES = getres(args.res[0])
            if HRES == 0 and VRES == 0:
                print('-ve values not allowed in --res, \
                       hres and vres cannot be 0 together')
                return
        else:
            try:
                if args.res[0].endswith('%'):
                    scale = int(args.res[0][:-1])
                else:
                    scale = int(args.res[0])

                if scale <= 0:
                    print('scale should be > 0%')
                    return
                if scale > 100 and not args.enlarge:
                    print('use --enlarge to scale > 100%')
                    return
            except Exception:
                print('invalid value for --res')
                return
    elif args.rotate is not None:
        rotate = args.rotate % 360
        if not rotate:
            print('cannot rotate by 0 degree')
            return
    elif args.convert or args.progressive or args.optimize:
        no_res_opt = True
        scale = 100
    else:
        print('missing image transformation')
        return

    if args.minres is not None:
        if 'x' in args.minres[0]:
            minH, minV = getres(args.minres[0])
            if minH == 0 or minV == 0:
                print('-ve values not allowed in --minres, \
                       H or V cannot be 0')
                return
        else:
            if scale is not None:
                print('both --res and --minres cannot be in percentage')
                return

            try:
                if args.minres[0].endswith('%'):
                    minscale = int(args.minres[0][:-1])
                else:
                    minscale = int(args.minres[0])

                if minscale <= 0:
                    print('--minres should be > 0%')
                    return

                minH = (HRES * minscale) / 100
                minV = (VRES * minscale) / 100
            except Exception:
                print('invalid value for --minres')
                return

    adapt = args.adapt
    convert = args.convert
    hidden = args.hidden
    eraseexif = args.eraseexif
    force = args.force
    includeimgp = args.includeimgp
    keep = args.keep
    enlarge = args.enlarge
    optimal = args.optimize
    progressive = args.progressive
    mute = args.mute
    recurse = args.recurse
    if args.size is not None:
        size = args.size
    if args.quality is not None:
        qual = args.quality
    overwrite = args.overwrite
    debug = args.debug
    if args.nearest:
        png_ip = PIL.Image.Resampling.NEAREST

    pool = Pool()

    for path in args.keywords:
        if not os.path.exists(path):
            print('%s does not exist' % path)
        elif os.path.isdir(path):
            traverse_dir(path)
        elif args.rotate is not None:
            if rotate_image(path):
                count += 1
        else:
            if resize_image(path):
                count += 1

    # Process current directory if PATH is unspecified
    if len(args.keywords) == 0:
        if not mute:
            print('Source omitted. Processing current directory...\n')
        traverse_dir('.')

    pool.close()
    pool.join()

    if not mute:
        # Show number of images converted
        if count:
            print('%s processed in %.4f seconds.' % (count, time.time() - init_time))

        # Show number of images not converted due to low resolution
        if count_lowres:
            print('%s not processed due to low resolution.' % count_lowres)


if __name__ == '__main__':
    main()
