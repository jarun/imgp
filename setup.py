#!/usr/bin/env python3

import re
import os.path
import shutil
import sys

from setuptools import setup, find_packages
from pkg_resources import get_distribution, DistributionNotFound

def get_dist(pkgname):
    try:
        return get_distribution(pkgname)
    except DistributionNotFound:
        return None

if os.path.isfile('imgp'):
    shutil.copyfile('imgp', 'imgp.py')

with open('imgp.py', encoding='utf-8') as f:
    version = re.search('_VERSION_ = \'([^\']+)\'', f.read()).group(1)

with open('README.md', encoding='utf-8') as f:
    long_description = f.read()

requirements = ['pillow-simd' if get_dist('pillow-simd') is not None else 'pillow']

setup(
    name='imgp',
    version=version,
    description='High-performance CLI batch image resizer & rotator',
    long_description=long_description,
    long_description_content_type="text/markdown",
    author='Arun Prakash Jana',
    author_email='engineerarun@gmail.com',
    url='https://github.com/jarun/imgp',
    license='GPLv3',
    license_file='LICENSE',
    python_requires='>=3.8',  # requires pip>=9.0.0
    platforms=['any'],
    py_modules=['imgp'],
    install_requires=requirements,
    include_package_data=True,
    entry_points={
        'console_scripts': ['imgp=imgp:main']
    },
    extras_require={
        'packaging': ['twine']
    },
    keywords='image processing resize rotate optimize',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: End Users/Desktop',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Natural Language :: English',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3 :: Only',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Topic :: Utilities'
    ]
)
