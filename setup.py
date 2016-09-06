#!/usr/bin/env python
# coding=utf-8

from setuptools import setup


package_name = 'imgd'


def get_version():
    import ast

    with open(package_name + '.py') as input_file:
        for line in input_file:
            if line.startswith('__version__'):
                return ast.parse(line).body[0].value.s


def get_requires():
    try:
        with open('requirements.txt', 'r') as f:
            requires = [i for i in map(lambda x: x.strip(), f.readlines()) if i]
        return requires
    except IOError:
        return []


def get_long_description():
    try:
        with open('README.md', 'r') as f:
            return f.read()
    except IOError:
        return ''


setup(
    # license='License :: OSI Approved :: MIT License',
    name=package_name,
    version=get_version(),
    author='',
    author_email='',
    description='Multiprocessing batch image resizer and rotator',
    url='https://github.com/jarun/imgd',
    long_description=get_long_description(),
    # Or if it's a single file package
    py_modules=[package_name],
    install_requires=get_requires(),
    entry_points={
        'console_scripts': [
            'imgd = imgd:main'
        ]
    }
)
